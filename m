Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaIZJOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:14:54 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56265 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaIZJOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:14:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joachim Eastwood <manabian@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Douglas Anderson <dianders@chromium.org>, kgene.kim@samsung.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        naushad@samsung.com, Li.Xiubo@freescale.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        thomas.ab@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        Lee Jones <lee.jones@linaro.org>, sunil joshi <joshi@samsung.com>,
        b29396@freescale.com
Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from platform devices
Date: Fri, 26 Sep 2014 11:14:30 +0200
Message-ID: <3291391.H71MjevFsA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGhQ9VwAe7d7fX1Lw22ocxDSXjOZbvXdmG1u6_d5v7ptmYMYeg@mail.gmail.com>
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com> <2553182.6YgvmDLuEA@wuerfel> <CAGhQ9VwAe7d7fX1Lw22ocxDSXjOZbvXdmG1u6_d5v7ptmYMYeg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Ax3vjhMVdQsMVEh8r/KDI63SLWzzMOZiltaeN53c3cd
 9gJS//sN6gZi1JFsT2GOv0I9fKLc4fe6Ooqzrl0nb7rzhpCf8y
 gxw+FXsLRUuKDDAgYyroQyHu+3I1P2yyDzsQWjGKTkhS2xKKN6
 3ov1mLmZtIUpg86ZZJT8gzP3pRGYCdXUSNTC0qr4aTTqqwXacI
 1mFGF77opmeBGPpeD9pZxgFNIsw8ToUpj7vOnE8lJZ5otATX8k
 mCKuvw2qZezLN7B843R3DI3VkrI0nFnKE3Zw/Mw3yiTn0UNvr/
 K7qtGaydyq8vTdyYbR3ucKc3vkkYXNMdPDhdwZDEohXTLhH6Pl
 1Ozp3QyrtT4Ze+WTCdE4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2014 09:48:24 Joachim Eastwood wrote:
> On 26 September 2014 09:16, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 26 September 2014 07:34:12 Joachim Eastwood wrote:
> >> I am working on Cortex-M4 no-MMU platform that isn't upstream yet, btw.
> >>
> >
> > Sorry for drifting off-topic, but this is very interesting to me. Can you
> > say which one you are working on and what your timeline is for submitting
> > it upstream?
> 
> It's NXP LPC18xx/43xx which is Cortex-M3/M4.
> 
> 3.19 or 3.20 might be target.

Ah, very nice!

> Right now everything is in a github repository here:
> https://github.com/manabian/linux-lpc
> 
> Most stuff are working now and I am in the process of clean it up and
> adding documentation.

Ok, looks like you are making good progress. I noticed three high-level
issues that you may want to address:

- the watchdog driver should use the generic watchdog framework rather
  than registering a misc device.
- the ehci glue can probably go away if you make very small changes
  to the generic ehci platform driver
- I don't like the way that the stmmac glue drivers are added, I thought
  we had fixed this before but I think I need to dig up old emails.
  The driver should really be a loadable module that hooks calls into
  the common code rather than being linked into one module.

I also have a plan for doing multiplatform builds of nommu kernels, 
for build testing mostly, I wouldn't expect you to run that configuration.
No need for you to address that yourself though, we'll get there.

	Arnd
