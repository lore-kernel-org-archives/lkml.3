Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbaJ3JNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:13:15 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:64787 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbaJ3JNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:13:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, lethal@linux-sh.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V2 10/15] irqchip: bcm7120-l2: Make sure all register accesses use base+offset
Date: Thu, 30 Oct 2014 10:12:30 +0100
Message-ID: <2226258.WJYuvIUVPE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414635488-14137-11-git-send-email-cernekee@gmail.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com> <1414635488-14137-11-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Np3i8NdMzrmBIwB5aK02n+NKgyCcgMtQmSykV9JP9Ky
 UCJ/K42KtALI2XozPSl0M3WGkthDqTFQ1+VesHiyd+MGWwnclb
 yHR8T2LJs5QbMdnjjdNJ2LUMOAOlS/313l6lmDpocJ7IW9VU9l
 EU5LFbzJG2U9SoGNaMibBcQ97vnVTD/2DQogRJwt/gGw9HRpMt
 vfxbyNaeq5aJu1xfDASNtZsMVsU0coE8EemOa2VumHx1nu2jZu
 fGIVEtZq/blnuJGylS9AWilmA33MAEj9h6gSnTKA8cp18n6KGo
 NIAwj0jkCg4ojmi7b1MKzhWI1Xn8w0Yl87jC7Ev1FDvU/+u9zm
 PRVXNT6cH1ATptHQTgyc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 19:18:03 Kevin Cernekee wrote:
> A couple of accesses to IRQEN (base+0x00) just used "base" directly, so
> they would break if IRQEN ever became nonzero.  Make sure that all
> reads/writes specify the register offset constant.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 

Now you no longer convert them this driver to use irq_reg_{readl,writel}, which
breaks support for big-endian ARM.

	Arnd
