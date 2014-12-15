Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaLOOHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:07:32 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:56171 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaLOOH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:07:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 5/8] mfd: Add ST's Low Power Controller driver
Date: Mon, 15 Dec 2014 15:06:50 +0100
Message-ID: <5276146.VV460E9Y1P@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141215135052.GC13885@x1>
References: <1418642738-17407-1-git-send-email-lee.jones@linaro.org> <2928949.OKYp272uiY@wuerfel> <20141215135052.GC13885@x1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:i8qpfiJ2xE581AA4aCPn9DitouK1Gx3I8ve3iG2janfTdrXMCjA
 /5t72xpySREOH0no0nsRJdl2H9zAIw+tZmSh5pwONNsl3hhAXKNCZsGv/9zUGw3E6zSYejx
 VVlTQpSXmxVDrrFiJCsAPCMvDPeuvS1In/te/okwYnFXLiV4+HUcmEgP1+2TZ+wTDjNcckA
 b8BnQPXN1ZEPgbhHXGuRQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 December 2014 13:50:52 Lee Jones wrote:
> > > 
> > 
> > I don't think it's necessary to have the MFD node if only one of the
> > two modes can be used based on a DT property. It should be enough
> > to have both the rtc and the wdt driver list the same compatible
> > string and check the property in the probe function to decide if
> > they want to drive the device or not:
> 
> I tried that and it didn't work.  Only one driver probed.
> 
> 

Strange, the code in really_probe() and the comment in device_attach()
suggest that this is not the intentional behavior. What error
code did you return? If it's -ENODEV or -ENXIO, it should keep
trying the other drivers, otherwise it will give up.

	Arnd
