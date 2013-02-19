Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab3BSQBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:01:10 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:41360 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab3BSQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:01:08 -0500
Subject: Re: Fwd: mmc card probe not getting called
From: anish kumar <anish198519851985@gmail.com>
To: chetan cr123 <chetancr123@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAJ8diHT5Ze3bsPGO7yLqPHu6niuDC_gtjJB=gKGoUXOfvoHtyw@mail.gmail.com>
References: <CAJ8diHTq6ayQjciiu_9fXyHYTk4DorT=5uw=759zHo7B81-e4w@mail.gmail.com>
	 <CAJ8diHT5Ze3bsPGO7yLqPHu6niuDC_gtjJB=gKGoUXOfvoHtyw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Feb 2013 21:25:43 +0530
Message-ID: <1361289343.16206.35.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 12:16 +0530, chetan cr123 wrote:
> HI All,
> 
> I am working on Sd Card/Block driver
> 
> I am registering it as both
> 
> 1. register_blkdev()-------------  BLOCK Regsiter
> 2. mmc_register_driver ------  MMC regsiter
> 
> and filling the mmc_driver structure.
> 
> I am not able to see the probe of MMC, But i see the return value of
> mmc_register function returning success.
I am not an expert on MMC driver but AFAIK it is no different in terms
of following device/driver model.
Probe of a function is only called when device name matches with driver
name and when it happens driver calls your probe.

So in your case even though you have registered the driver, looks like
you are missing the device registration part.Do that and see the magic.
If this is SOC then that is done in the board file i.e.
arch/arm/plat-xyz/....

> 
> Kindly let me know how i make the probe of mmc getting called
> 
> Thanks
> 
> 
> Chetan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


