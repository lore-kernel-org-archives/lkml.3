Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3FZGMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:12:00 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:50375 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3FZGL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:11:58 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: SATA hdd refuses to reallocate a sector?
Date: Wed, 26 Jun 2013 08:11:15 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Mark Lord <mlord@pobox.com>, Pavel Machek <pavel@ucw.cz>,
        Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
References: <20130623101940.GA4448@amd.pavel.ucw.cz> <51C83907.2020202@pobox.com> <1372215862.2806.54.camel@dabdike>
In-Reply-To: <1372215862.2806.54.camel@dabdike>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201306260811.15421.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 June 2013, James Bottomley wrote:
> On Mon, 2013-06-24 at 08:18 -0400, Mark Lord wrote:
> > And the SCSI stack in Linux has rather atrocious error handling.
> > It lumps multiple requests together, and can fail the entire lot even
> > if only a single sector is bad.
>
> That's rather misleading.  SCSI doesn't lump anything together; it
> handles the requests it was passed.  For reads and writes through the
> page cache, block will aggregate in the elevators, but you avoid that by
> not using the page cache (O_DIRECT or SG_IO).

Yes, it works fine with O_DIRECT - that's why hdd_realloc reads 
sector-by-sector when an error was detected. I'd also like to disable read 
retries but that does not seem to be possible.

> For devices which report failing sectors correctly data up to the failed
> sector is returned and the request is shortened and retried from the
> failed sector on.  If we get a second failure at the beginning (where
> the previous bad sector was), then we give up.
>
> James


-- 
Ondrej Zary
