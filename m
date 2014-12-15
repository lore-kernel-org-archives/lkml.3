Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaLOOjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:39:04 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38704 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaLOOi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:38:58 -0500
Date: Mon, 15 Dec 2014 14:38:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 5/8] mfd: Add ST's Low Power Controller driver
Message-ID: <20141215143850.GD13885@x1>
References: <1418642738-17407-1-git-send-email-lee.jones@linaro.org>
 <2928949.OKYp272uiY@wuerfel>
 <20141215135052.GC13885@x1>
 <5276146.VV460E9Y1P@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5276146.VV460E9Y1P@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014, Arnd Bergmann wrote:

> On Monday 15 December 2014 13:50:52 Lee Jones wrote:
> > > > 
> > > 
> > > I don't think it's necessary to have the MFD node if only one of the
> > > two modes can be used based on a DT property. It should be enough
> > > to have both the rtc and the wdt driver list the same compatible
> > > string and check the property in the probe function to decide if
> > > they want to drive the device or not:
> > 
> > I tried that and it didn't work.  Only one driver probed.
> > 
> > 
> 
> Strange, the code in really_probe() and the comment in device_attach()
> suggest that this is not the intentional behavior. What error
> code did you return? If it's -ENODEV or -ENXIO, it should keep
> trying the other drivers, otherwise it will give up.

Oh I see.  So if I return -ENODEV it will keep trying to bind with
other drivers.  I'll try that and report back.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
