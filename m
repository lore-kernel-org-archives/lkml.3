Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaCJR5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:57:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:58175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaCJR5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:57:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com
Subject: Re: [PATCH v4 6/7] DMA: sun6i: Add driver for the Allwinner A31 DMA controller
Date: Mon, 10 Mar 2014 18:57 +0100
Message-ID: <5055473.2ZTHMWo41J@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140310165156.GI2815@lukather>
References: <1394462512-11620-1-git-send-email-maxime.ripard@free-electrons.com> <2475487.axlvKsBQ0c@wuerfel> <20140310165156.GI2815@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7L0nkbPbwXhDvnu18ReowaL6aX0ab2XOX3RtMdkyk3U
 28OGb7sght9V8+LjedAKu6q+RxeNTgbekDSax4rhpOARdshzfg
 AxvfM23jBaSyhZtitPqXUIWWJwamv36lFVlI7ddcWnsTBd7s5T
 1A6J0vbnoauFJ9HpyUAZq6W5R+J/IgYNtUntxqlscciW7ZI26n
 NOxfUf5OyLftQsqMnHYBk/Ddq8NSO26EOvhbm6l3ahlA1VyH0+
 /TXN2/ZetJt+y/JaEzzsCryj5X/iFwXOxmTdT2zF1ZeRsXL1/1
 jWP4KPmKURPwFzXhQewqyeSEGrfJXBE4+aRWPSPzu9qwFa6njn
 CDLrjvTmjdCntQJ9v3qg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014 17:51:56 Maxime Ripard wrote:
> > 
> > Neither "pll6" nor "ahb1_mux" are listed in the DT binding. Also, why
> > is it the driver's business to set the parent?
> 
> Those are global clocks, so it's not really part pof the driver
> binding itself. But I can add them.

No better don't then. Can you change the clk_get() call to pass
NULL as the device pointer to clarify this in the source though?

> About the reparenting itself, other devices are actually fine having
> any parent they want, only the DMA is picky about it (at least, from
> what we know), so it made sense to me to put it into the driver
> itself. Where would you put it?

Maybe Mike Turquette has an idea. We have in the past discussed
about cases where you want the default clock setting to be part
of the clock provider in some property. Could that work here?

	Arnd
