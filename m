Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaEHPiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:38:55 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:60138 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaEHPiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:38:52 -0400
Date: Thu, 8 May 2014 19:38:45 +0400
From: Paul Fertser <fercerpav@gmail.com>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
Cc: "balbi@ti.com" <balbi@ti.com>, "LeoLi@freescale.com" <LeoLi@freescale.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fsl: check vbus presence on probe
Message-ID: <20140508153845.GA3876@home.lan>
References: <1398329653-29968-1-git-send-email-fercerpav@gmail.com> <20140430160625.GF23679@saruman.home> <20140430192745.GI3876@home.lan> <20140430201202.GF3839@saruman.home> <2cd9b3e31cce467e9a79d7aabd63604b@BL2PR03MB579.namprd03.prod.outlook.com> <59ef67eabf72450f988638edbbe1cd47@BL2PR03MB579.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59ef67eabf72450f988638edbbe1cd47@BL2PR03MB579.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 08, 2014 at 02:30:39PM +0000, suresh.gupta@freescale.com wrote:
> As per my limited knowledge, the purpose of
> OTGSC_STS_B_SESSION_VALID bit is to tell either VBUS is above the B
> session valid threshold and which comes only Host is attached.

Yes, that matches the datasheet I've read.

> And Host might be attach after system bootup or after driver
> initialization. So putting this check in probe will not help much.

If the host is attached after the driver was initialised, the
interrupt will trigger and the driver will get notified that VBUS
appeared and everything will go smooth, at least that's how it should
work (I do not have any board handy to real-life check that, but
AFAICT that's the intent of the current code).

I actually do not have any iMX demoboards at all, I've only got some
custom-designed i.MX25 boards where I can't control VBUS, it's
permanently pulled up.

But I was fixing the problem that was clearly, 100% reproducibly
happening when VBUS was applied before the interrupt was
configured. So what exactly do you mean here? Do you mean this check
I've added doesn't fix the bug? Or do you mean this bug should be
fixed somehow else? Or do you mean there's no bug in the first place
and my board doesn't work because of something else?

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
