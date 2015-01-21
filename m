Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbbAUHqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:46:49 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:53859 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbAUHqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:46:39 -0500
X-ME-Helo: beldin
X-ME-Date: Wed, 21 Jan 2015 08:46:36 +0100
X-ME-IP: 109.222.126.211
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Lee Jones <lee.jones@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v3 2/3] mfd: lubbock_io: add lubbock_io board
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
	<1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
	<20150119091705.GG21886@x1> <87ppaah9k5.fsf@free.fr>
	<20150120102919.GP5767@x1>
	<20150120115658.GJ26493@n2100.arm.linux.org.uk>
X-URL: http://belgarath.falguerolles.org/
Date: Wed, 21 Jan 2015 08:46:29 +0100
Message-ID: <873874fuei.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> What I'd suggest (and always have done) is:
>
> 	dev_err(&pdev->dev, "couldn't request main irq%d: %d\n",
> 		irq, ret);
I like it, it's even more compact, I'll use it for next patch version.

> but I guess printing the IRQ number no longer makes sense with todays
> dynamic mapping of logical IRQ numbers, as it is no longer meaningful.
Yes ... we're not yet there with pxa gpio interrupts, maybe it will come
eventually one day.

For Lee:
> > > platform_get_irq()?
> > No. I need the flags.
> Where are they used?
A couple of lines below, using local "irqflags" variable :
       ret = devm_request_irq(&pdev->dev, cot->irq, lubbock_irq_handler,
                              irqflags, dev_name(&pdev->dev), cot);

Cheers.

-- 
Robert

