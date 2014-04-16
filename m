Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaDPMan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:30:43 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33275 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaDPMam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:30:42 -0400
X-Auth-Info: jDkiKqNcwNYNCes7buuhMIAWNxkXufkqb2o80pwbEAU=
From: Marek Vasut <marex@denx.de>
To: Austin Boyle <boyle.austin@gmail.com>
Subject: Re: [PATCH v2] mtd: m25p80: Calculate flash block protect bits based on number of sectors
Date: Wed, 16 Apr 2014 14:30:39 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.02.1404062115570.19515@austin-Satellite-L510> <201404131924.03967.marex@denx.de> <alpine.DEB.2.02.1404162216160.3848@austin-Satellite-L510>
In-Reply-To: <alpine.DEB.2.02.1404162216160.3848@austin-Satellite-L510>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404161430.39384.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 16, 2014 at 02:26:41 PM, Austin Boyle wrote:
> On Sun, 13 Apr 2014, Marek Vasut wrote:
> > This portion of code looks like a duplicate of ...
> > 
> > > +	for (lock_bits = 1; lock_bits < 7; lock_bits++) {
> > > +		protected_area_start = flash->mtd.size -
> > > +					get_protected_area(flash, lock_bits);
> > > +		if (offset+len >= protected_area_start)
> > > +			break;
> > > +	}
> > > +	lock_bits--;
> > > +
> > > +	status_new = (status_old & ~SR_BP_BIT_MASK) |
> > > +			((lock_bits << SR_BP_BIT_OFFSET) & SR_BP_BIT_MASK);
> > 
> > ... this here (if you don't consider the lock_bits--) . Why don't we move
> > this into a separate function to avoid the duplication?
> 
> Thanks for reviewing this patch Marek, your suggestions were very
> helpful. I am about to post another version that
> hopefully addresses the issues raised, I would appreciate if you can take
> another look at it.

Actually, thank _you_ for working on this :)

Best regards,
Marek Vasut
