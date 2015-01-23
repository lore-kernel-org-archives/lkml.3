Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbbAWQci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:32:38 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:39773 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbbAWQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:32:37 -0500
Date: Fri, 23 Jan 2015 16:32:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 2/8] irqchip: Supply new driver for STi based
 devices
Message-ID: <20150123163231.GB11745@x1>
References: <1421920133-7914-1-git-send-email-lee.jones@linaro.org>
 <1421920133-7914-3-git-send-email-lee.jones@linaro.org>
 <alpine.DEB.2.11.1501231702280.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.11.1501231702280.5526@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Thomas Gleixner wrote:
> On Thu, 22 Jan 2015, Lee Jones wrote:
> 
> > This driver is used to enable System Configuration Register controlled
> > External, CTI (Core Sight), PMU (Performance Management), and PL310 L2
> > Cache IRQs prior to use.
> 
> I'm wondering how this is related to irq_chip, 

It doesn't really.  At least, it doesn't make use of the framework.  
It was the most relevant subsystem.

> but well, I don't mind it being parked here.

Thanks Thomas.  I was hoping for that response.

> Though I really cannot say anything about this DT translation
> machinery for a single sysconfig register, other than it looks
> completely overengineered to me.

I understnad where you're coming from, but don't all drivers just
'twiddle some register bits'?

> The only technical comment I have is: shouldn't all the stuff except
> the resume function be marked __init or is any of this required post
> init?

It's not common to mark functions invoked at and affter *_probe() as
__init.  At least, not as far as I'm aware.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
