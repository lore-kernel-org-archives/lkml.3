Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaJVIXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:23:35 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56622 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaJVIXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:23:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH v5 1/6] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Date: Wed, 22 Oct 2014 10:22:22 +0200
Message-ID: <12157660.uOkg5nk8Dq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5446F61C.8060400@broadcom.com>
References: <1413341936-17606-2-git-send-email-sbranden@broadcom.com> <38587325.kaAxCWAsmL@wuerfel> <5446F61C.8060400@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LKYzBcBjr75MRn5WRbrDIgTqErtrJ+11o8SajN1GNU8
 00wmEf5TACA7oj+YcV5QiZdDYg0onIASqv5IRsT1g5dNSAOdQR
 SYzba7UwlyY38R1szjoZgOclSNP2523sqDSbqHU74udYQotRgK
 fncRd+lAxj/HKa5JRQNmrL6zmO1AFHqS3ErxfOKwBxlx4YecWc
 DPOA9NKchJogpLCoanXQy84tdR/598jq8uFWIAfG1BDOHrI/mS
 9cUeaMveN3r57W4VAwQ4FeRlIGd/+XYZKASdOqB2jC/8naHmjc
 G9hGOMNAmIcvdcpeXBm2lg9cpkVZVOrYkSMSA2r3IUOREKFCwB
 jte4pi3oxmmYNCc8hWRQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2014 17:11:08 Scott Branden wrote:
> OK, I will remove the "iProc SoC based Machine types".  This was 
> grouping all iProc based SoCs under one menu and parallels what the 
> existing "Broadcom Mobile Soc Support" menu does.
>
> I can create another patch removing the "Broadcom Mobile SoC Support" 
> menu if the ARM Maintainer now want all Broadcom devices are supposed to 
> be contained in a single level?

Sounds good, I missed that other menu going in.

It can make sense to add 'comment' statements if you want to separate the
families.

I also noticed that there are a few configuration options that at first
seem pointless: ARCH_BCM_MOBILE_L2_CACHE and ARCH_BCM_MOBILE_SMP. I wonder
if it ever makes sense to disable these when the common options (CACHE_L2X0
and SMP) are enabled for another SoC. I'd normally like to see these as
hidden options that are always on whenever the core support for those
features is enabled, to avoid confusing users as well as bugs from the
combinatorial explosion.

	Arnd
