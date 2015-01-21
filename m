Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbbAUJr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:47:27 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43235 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbbAUJrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:47:21 -0500
Date: Wed, 21 Jan 2015 09:47:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v3 2/3] mfd: lubbock_io: add lubbock_io board
Message-ID: <20150121094711.GP26493@n2100.arm.linux.org.uk>
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
 <1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
 <20150119091705.GG21886@x1>
 <87ppaah9k5.fsf@free.fr>
 <20150120102919.GP5767@x1>
 <20150120115658.GJ26493@n2100.arm.linux.org.uk>
 <873874fuei.fsf@free.fr>
 <20150121081645.GC9258@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121081645.GC9258@x1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 08:16:45AM +0000, Lee Jones wrote:
> On Wed, 21 Jan 2015, Robert Jarzmik wrote:
> > > > > platform_get_irq()?
> > > > No. I need the flags.
> > > Where are they used?
> > A couple of lines below, using local "irqflags" variable :
> >        ret = devm_request_irq(&pdev->dev, cot->irq, lubbock_irq_handler,
> >                               irqflags, dev_name(&pdev->dev), cot);
> 
> No, I mean where are they _used_?

They're used in request_irq, and request_irq uses it to set the interrupt
type (edge or level) as specified in the IRQ resource.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
