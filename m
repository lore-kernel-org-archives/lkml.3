Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3BJVQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 16:16:36 -0500
Received: from mout.gmx.net ([212.227.15.18]:61370 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab3BJVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 16:16:35 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX19fFXFnhCxfFUNXdXLkHbKIz940rLQ5CiywKeC4Dr
	Sa9xzM45zINm+F
From: Marc Dietrich <marvin24@gmx.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        arnd@arndb.de, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Date: Sun, 10 Feb 2013 22:16:14 +0100
Message-ID: <1828614.u7HcYf891a@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-21-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <51180121.6040803@wwwdotorg.org>
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com> <2499199.srlLvkihNZ@ax5200p> <51180121.6040803@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2013 13:20:49 Stephen Warren wrote:
> 1On 02/10/2013 10:28 AM, Marc Dietrich wrote:
> > On Friday 08 February 2013 10:09:10 Stephen Warren wrote:
> >> On 02/08/2013 05:29 AM, Marc Dietrich wrote:
> >>> Hiroshi,
> >>> 
> >>> Am Freitag, 8. Februar 2013, 09:29:31 schrieb Hiroshi Doyu:
> >>>> Refactored tegra{20,30,114}_init_early() so that we have the unified
> >>>> tegra_init_early().
> 
> ...
> 
> >>> are these ifdefs really needed? Multisoc kernels will enable them all
> >>> anyway and there is a case structure which protects the assignments.
> >>> Also
> >>> the hotplug functions are very tiny, so there shouldn't be a big loss.
> >> 
> >> The files that contain/implement those functions are separate for each
> >> SoC and only included in the build when the individual SoCs are enabled.
> >> 
> >> While multi-platform SoCs do make sense for distros, we also very
> >> specifically want to support the case where only Tegra, and only a
> >> single Tegra SoC, is enabled, hence this separation.
> > 
> > Huh? so tegra_defconfig is not supported?
> > 
> > grep "TEGRA_.*_SOC" tegra_defconfig:
> > 
> > CONFIG_ARCH_TEGRA_2x_SOC=y
> > CONFIG_ARCH_TEGRA_3x_SOC=y
> 
> I don't understand the question.
> 
> But to be clear. There are now 3 variants of Tegra supported. (Tegra20,
> Tegra30, Tegra114). We want to be able to build a minimal-size kernel
> (e.g. for embedded applications) that supports just one, any combination
> of two, or all three Tegra variants.

ah, ok - I just skipped the "also" in your sentence above. But still, the 
#ifdefs look strange to me and save only a few byte of code. Just me few 
cents.

Marc

