Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaELJrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:47:39 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:63989 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaELJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:47:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 0/4] Introducing Exynos ChipId driver
Date: Mon, 12 May 2014 11:47:04 +0200
Message-ID: <4593340.mEX4CtCUDb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140512014728.GA6054@quad.lixom.net>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com> <4239261.HFHm7SU1iH@wuerfel> <20140512014728.GA6054@quad.lixom.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RiAWLkQWnW9G5jZiDeo99XEDgUp6tMdSa7eIEZsrlq8
 c5GKeEjcjGuTxet4zfQBg5wZKwV9lm4LBB280/ajYMC2SDRpoA
 vRYT2N2VWtCwEUDzgRm9W2VZNrFz94bxsgKjttFW+m2J8OdC9d
 uFP8UxWBl7ajz4DSkT5W9nB/VnaFbgDIIBlzpzDHJDY69Str4x
 rH+c8Phr63iCmVR350xwi5bEP6obO3IHz8I58wsGAHAS2yvTfo
 ymbCPy1BCAXTzhKgMQ0KUL+C+ASf0QqPmFyIAzqKv+FUfSrfRH
 td9wQZvS707RzgGsQ/pL57hh99bVfVgrsIpqcX8GSJX1kH9vuh
 KgWNAicXiqwuJOOnXYxQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 May 2014 18:47:28 Olof Johansson wrote:
> > > Also for platsmp.c and pm.c I can think of following approaches
> > > 1: Keep these macros till we get generic solution?
> > > 2: Allow chipid driver to expose APIs to check SoC id and SoC revisions 
> > > till we get
> > > generic solution. So that at least we can remove #ifdef  based macros
> > > as soc_is_exynosXYZ.
> > > 3: Use of "of_flat_dt_is_compatible" or similar APIs in these machine files 
> > > till we get
> > > generic solution. For some cases where we want to know SoC revision let us
> > > map chipid register and get revision there itself.
> > > 
> > > Please let me know what approach you think will be good?
> > 
> > I think 1 or 2 would be better than 3. Between those two, I'm undecided,
> > but I think either way the SoC specific values would be better kept in the
> > mach-samsung directory than in plat/cpu.h or linux/exynos-chipid.h.
> 
> The generic solution is already there: of_machine_is_compatible() is perfectly
> sensible to use for _some_ of these inits. Cpufreq is one of the few that comes
> to mind, and maybe some of the platsmp and pm stuff.
> 
> Note that none of them should be used in runtime, i.e. you should only use them
> at probe/setup time and maybe have a local state in the driver if needed.
> 
> I'd rather get people used to that format than everybody needing to implement
> a chipid driver now too, especially on platforms that might not even have a
> suitable chipid block to base a driver around -- not to mention having to
> fill the namespace with is_soc_*() stuff.

I was coming from the other angle: exynos is already using soc_is_*() in too
many places. I'd like to first see the ones cleaned up that really should be
doing something else because they have a device-local ID to look at.

If we end up with a couple of instances that don't have a good alternative,
we can use of_machine_is_compatible() for those, but I'd like to avoid doing
a blind conversion because that would likely lead to more instances in the
future, not fewer.

I agree that we should have to introduce new chip ID drivers on other
platforms for the purpose of finding out the SoC version, especially not
with private APIs.

	Arnd
