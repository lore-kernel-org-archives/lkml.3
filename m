Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3BFQas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:30:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3BFQar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:30:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org, arm@kernel.org,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] OMAPDSS: enable omapdss for ARCH_MULTIPLATFORM
Date: Wed, 06 Feb 2013 15:29:52 +0100
Message-ID: <3969096.QosOfOb9QT@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-3-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <5112659D.50808@ti.com>
References: <1358891160-9534-1-git-send-email-robdclark@gmail.com> <201302051631.40254.arnd@arndb.de> <5112659D.50808@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0+beMHKdryfbdxXFlMqg9tekKdogotFx5Ddud7rvHq5
 RFS2DdPu0nYzRDNVvmnEnmHmY0ryxQeJD95Zdl/YXgMECU2ufy
 Y3lEJ03FyAvYMByn8RR/ll1xF/izd2jegGO6boPKhHe50vCqlJ
 BRUJ1pWnyLjcvt7D0fNzYBmiCWoEL5sn8APHx37YpkYXvf+TyE
 jeNEyBtg2Eoq2uOO2AS+zDagtl/fHiOz9xBa6wkZ1qomO2zHej
 lPX7k2zHDv1OAKyQmRosPZiR9GRBkbmSDrLNucqES8vK421Ke4
 JBKucPweszaoYfQB+wh531UgXGPKscgcge3nujF1xHMErgt/TV
 CDoRB7Mq5x6FLZfVSd4M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013 16:15:57 Tomi Valkeinen wrote:
> 
> That would normally be me, but I've been on a long leave, and just came
> back. It'll take me some time to get back on track.
> 
> I don't think it makes sense to add ARCH_MULTIPLATFORM only for omapdss,
> like this patch does. I think we should add it for omapfb and the panel
> drivers also.
> 
> I did get a report of an omapdss build-break with allyesconfig. It seems
> to happen because omapdrm and omap_vout use "select" to enable omapdss,
> instead of depending on omapdss. This causes an illegal config to be
> created. Perhaps this is the problem that Rob mentions in his patch?

Yes, that is the one. It is one of three remaining build errors
we get for ARM allyesconfig, and the other two also have fixes
on their way into 3.8.

> Adding ARCH_MULTIPLATFORM for omapdss, as this patch does, removes
> (well, hides) the above mentioned problem and allyesconfig works ok. You
> can still break the config, but you need to manually select the Kconfig
> options the wrong way.
> 
> I have patches to add the ARCH_MULTIPLATFORM for omapdss, and to fix the
> omap_vout and omapdrm Kconfig files. Each of them changes only one line.
> Arnd, are you ok with queuing those patches via arm-soc/fixes? Or should
> I send them individually to respective maintainers?
>
> I can send the patches properly for review, but I've also attached them
> here so Rob can test.

The second and third attachment in your mail seem to contain identical
patches. I suggested a similar patch myself, but Rob thought his
version was nicer to give better build coverage. We only need either
Rob's patch or yours, but not both, as far as I can tell.

Olof can correct me, but I think we currently don't have any other
patches queued in arm-soc for 3.8 (after Linus announced he did
not want any of the less urgent ones), so I think it would be more
fitting if you send one of the patches to Linus, rather than having
an arm-soc pull request that only contains one patch in your domain.

	Arnd
