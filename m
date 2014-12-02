Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaLBJm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:42:59 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:53328 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaLBJmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:42:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Tue, 02 Dec 2014 10:41:57 +0100
Message-ID: <3316464.yrAZ5QMKbg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1724175.Jqk8gQW3pz@ws-stein>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <2417519.MDE3mu6n7n@wuerfel> <1724175.Jqk8gQW3pz@ws-stein>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WA2KuRto5UVyvZ1br1ykhmHa5lW/avtM72lYgVIUeID
 W6MnTWJVRrFgQo3EyP3j1b1n6zphQ5zZbJ/oYB5bUYZSP4hDci
 8PGKBYo4RY/JsapSL9v018RLUpqX07myzcLhpeMVGZmlUg2HKK
 G0hyyDuo4t1IgsdRMDlFNdtCs5MhWPOx6TWkAyuo+BcBchHzUU
 GgJ1BSVvnesO07mOxiLJIo4YeB591wj0jW/SjAIaBZECier2ZF
 j+WtUxSIzh4SMryQH+S9na8J4cBsTNhckA51yM58Z6Or6JI1jR
 66Iv+UhW5TZjNnWwx/DWTO+8/zhRusuF7ZA3Pp7nwBmijpnatc
 rV9un49u1WQ2gxO/zZts=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2014 10:18:45 Alexander Stein wrote:
> On Monday 01 December 2014 17:17:30, Arnd Bergmann wrote:
> > On Monday 01 December 2014 11:50:06 Boris Brezillon wrote:
> > > 
> > > I don't have a strong opinion regarding where this driver should
> > > live (I even considered putting it in drivers/bus) :-).
> > > But note that there are other "external memory interface" drivers
> > > in drivers/memory too: TI AEMIF and Marvell DEVBUS  ;-).
> > > 
> > > Does anyone else think this driver should go in drivers/bus ?
> > > 
> > 
> > I think drivers/memory is better.
> 
> I don't mind if it's drivers/bus or drivers/memory. But I'm 
> wondering: When is a driver a bus driver when it is a memory
> driver? See imx-weim and atmel-ebi. Apparently both add support
> for devices attached on a bus which can be accessed through memory
> addresses.

I think drivers/memory should be used for external buses with an
SRAM or DRAM interface that need to configure the timings.

drivers/bus is more a collection for random other buses, usually
internal to a chip, but it's less well-defined.

	Arnd

