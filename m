Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbaEEPCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:02:01 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59030 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbaEEPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:02:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 0/4] Introducing Exynos ChipId driver
Date: Mon, 05 May 2014 17:01:53 +0200
Message-ID: <5374218.SlGnAKNqhD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4239261.HFHm7SU1iH@wuerfel>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com> <536758AB.2060503@samsung.com> <4239261.HFHm7SU1iH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Zh78zlUBvGQ0iVFwUBy583SdnBdmhOzgiXOfhXYPkrH
 xiIEAgayrAYxHvhAB/ckiQyvLBBQID9Brezas8g9W++orPntxB
 MO4aSMgTh7yrkETsqmF+wqdxvC6clq5tyfEXst1Rf3haFcA0FA
 YAah8tA7pkdmnacUYBlzdjNts8XonLEgWEqXHPCsTZmSwXeZvZ
 OmEQ88fUQkJHaqfWSPbe2ieog+y+ZXW4eZs3vslE6hTbJ5N8Jf
 LAtH3G02CMwZ5XeRFdsiv9KkQ4uYhurnTLLOmV+1wSAIiZFbrZ
 UcOFLsTtjY4cUfyTHzg+nbvMzcf0FZVAL7z6O72DglfG8x+DxB
 p/HUCEDdhrpO5cvybAEA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2014 16:58:14 Arnd Bergmann wrote:
> > Also for platsmp.c and pm.c I can think of following approaches
> > 1: Keep these macros till we get generic solution?
> > 2: Allow chipid driver to expose APIs to check SoC id and SoC revisions 
> > till we get
> > generic solution. So that at least we can remove #ifdef  based macros
> > as soc_is_exynosXYZ.
> > 3: Use of "of_flat_dt_is_compatible" or similar APIs in these machine files 
> > till we get
> > generic solution. For some cases where we want to know SoC revision let us
> > map chipid register and get revision there itself.
> > 
> > Please let me know what approach you think will be good?
> 
> I think 1 or 2 would be better than 3. Between those two, I'm undecided,
> but I think either way the SoC specific values would be better kept in the
> mach-samsung directory than in plat/cpu.h or linux/exynos-chipid.h.

Actually, a good compromise for now would be to add the chipid driver
to mach-exynos instead of drivers/bus. This way you can keep the uses
of the ID local to the exynos platform code until it's no longer needed.
Then it can get moved out to drivers/soc to be shared with arm64.

	Arnd
