Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3BGMuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:50:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61914 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3BGMux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:50:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH] OMAPDSS: enable omapdss for ARCH_MULTIPLATFORM
Date: Thu, 7 Feb 2013 12:50:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org, arm@kernel.org,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
References: <1358891160-9534-1-git-send-email-robdclark@gmail.com> <201302071155.12565.arnd@arndb.de> <51139E63.2030302@ti.com>
In-Reply-To: <51139E63.2030302@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302071250.39923.arnd@arndb.de>
X-Provags-ID: V02:K0:GhuH+LMfcJzWt8govZt4TnODur6rlOJJ724qhanWrin
 fFPv5RU9kd87bJP6y1kCbSbI60jRSD9c7J5BUMng+R8crEqKaG
 1UO/Lxv5DxW8FwIgllfdeocFux65R2OfM6Xl381yMzZWFUyKS0
 2q6obSO5s0X8q56awRiX8yswk8C3HZn3IvfgiKorlNluIcrElT
 3SWgoP7n521ua+FHTwIjuACwFFsVFDJTfAL5Fr0Vly0v63i2RN
 L2N+YSOtyC6wkNcS0LezwTbLlTVY9hhEpWZPp5QTF08RQYHTgT
 6WU4He7peM766vscY11MpszKP8Be+T/sF9zAbdSe3UJttANow+
 B0CHy8Ligj9ML/h/psTI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Tomi Valkeinen wrote:
> > I would suggest only the first patch, since Linus quite specifically
> > asked only for serious bug fixes. I think an allyesconfig build
> > breakage is serious enough, but doing multiple patches for one
> > bug should not be necessary and is much harder to justify.
> 
> Well, as I see, the bug is omapdrm using "select", not "depends on". So
> if I'd have to pick one patch, I'd send 0003. That would fix allyesconfig.
> 
> Applying only 0003 means that omapdrm (and omapdss) won't be built on
> ARCH_MULTIPLATFORM, but building omapdrm on ARCH_MULTIPLATFORM is a
> feature added in this merge window, so leaving it out is not a regression.
> 
> But I'm not sure if I'm being overly pedantic here. Patch 0001 would fix
> allyesconfig, and allow building omapdrm with ARCH_MULTIPLATFORM.
> However, the fixing there happens as a side effect, and so the 0001
> patch isn't even called a "fix" in its subject. That's the reason I'm a
> bit reluctant with the 0001 patch as a fix.

Makes sense. I suggested the same initially, but Rob preferred enabling
DSS on multiplatform as well, since he wants to see broad build coverage
for the DRM part. We should probably do that in 3.9, but for 3.8,
just changing DRM to depend on DSS seems like the least intrusive
choice.

	Arnd
