Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3FZDE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:04:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38723 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab3FZDE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:04:26 -0400
Message-ID: <1372215862.2806.54.camel@dabdike>
Subject: Re: SATA hdd refuses to reallocate a sector?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mark Lord <mlord@pobox.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, Pavel Machek <pavel@ucw.cz>,
        Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Date: Tue, 25 Jun 2013 20:04:22 -0700
In-Reply-To: <51C83907.2020202@pobox.com>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
	 <51C76858.4060906@pobox.com> <20130623215100.GA7414@amd.pavel.ucw.cz>
	 <201306240914.29502.linux@rainbow-software.org>
	 <51C83907.2020202@pobox.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 08:18 -0400, Mark Lord wrote:
> And the SCSI stack in Linux has rather atrocious error handling.
> It lumps multiple requests together, and can fail the entire lot even
> if only a single sector is bad.

That's rather misleading.  SCSI doesn't lump anything together; it
handles the requests it was passed.  For reads and writes through the
page cache, block will aggregate in the elevators, but you avoid that by
not using the page cache (O_DIRECT or SG_IO).

For devices which report failing sectors correctly data up to the failed
sector is returned and the request is shortened and retried from the
failed sector on.  If we get a second failure at the beginning (where
the previous bad sector was), then we give up.

James


