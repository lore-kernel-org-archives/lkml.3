Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762904Ab3DCKFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:05:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762607Ab3DCKF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:05:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: soc for 3.10 #2
Date: Wed, 3 Apr 2013 10:02:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>
References: <5152B357.3020500@atmel.com> <CAOesGMiy7q-xbc0SN78d7cvZmLgywy1PH7_Srw_=pzErSkrt-g@mail.gmail.com> <515BD8C8.5060701@atmel.com>
In-Reply-To: <515BD8C8.5060701@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304031002.41770.arnd@arndb.de>
X-Provags-ID: V02:K0:5l8k6rbHPoHDMBJCrMlrxQT0bYZ2gXNX9boeaXj143n
 fcb5or9NRQvRISA+ty+DTrPDbqxqrvOZx8wTkHCJQW8BF3dPxS
 n39F/fuFHHTOn2DuDnN+M4IFDw3HU791uU1ym2GcUBoMM2uX9Y
 DpDVj+9aoyG5BssO1K/FUBHN+XsX+hOqp6UXGZ2+BvHb3lhLWP
 qk4uqjdQ4aC3ehMa4ARMr5JLSZ9V9XZvHob6Zc63ysgedxsI/W
 RNAehQRJJWDS73h+S6vZrB7+Y7txjR4yzsONVMqVhMQf3pv/xc
 vAhaEduBU11Y7zDdyzGvFIu5yQ8wGgtNKFVIu8I+U5HSTAcR9L
 2JtlPDA4sRfBF0lNMElI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 April 2013, Nicolas Ferre wrote:
> > Also, USE_OF isn't set at that point (it's controlled by the next
> > section), so it can't be used as a replacement.
> > 
> > Also, isn't it a bit backwards in the first place to first set ATAGS
> > vs no-ATAGS, and then get to choose what hardware you want to build
> > for?
> 
> True, I was thinking it was a common pattern.

It's not common yet, but I want to get to the point where we can
globally disable ATAGS support for multiplatform kernels and get
only DT-enabled ones. There is no easy rule for when to select
or depend on a global feature, but there are a number of cases where
I think 'depends on' makes more sense in the long run.

Another example is CPU architecture level. Traditionally every
board selects CPU_v6 or CPU_v7, but in ARCH_MULTIPLATFORM, I created
a filter that lets you enable only one of them, and then pick all
the platforms that have the respective CPU, which is much easier
than having to know which platforms might be ARMv6 if you want to
build e.g. a kernel with THUMB2 support but as many boards enabled
as possible.

	Arnd
