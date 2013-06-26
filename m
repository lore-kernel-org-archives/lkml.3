Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3FZSwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:52:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FZSwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:52:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] arm: add early_ioremap() support
Date: Wed, 26 Jun 2013 20:52:09 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Leif Lindholm <leif.lindholm@linaro.org>, nico@linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306262052.09640.arnd@arndb.de>
X-Provags-ID: V02:K0:nUow+mOgcHM99zKs3dvp/I7va9HICSWr+YZGYUS/LvM
 cbC5773/TV+xLciiZ5xEplahCpPsNNjiuA1A4Trw5RezXwPquu
 nyhW65aIuS74E2zFcT4g78qaOM6b6kZpQaO3ZBRk9y8chHczjS
 sibmcR9J2+MwqqEVueOtzO5pI2+/ndmyfmgfezN1yee03kExjG
 CxAurADA2hXbToGHGSgWh2/Bwa0mBwv6ho7ARbBYaWdTMXzWBQ
 7QJ99gWt04Z36FIP6CnkQ5Hs2WpBh61DQ64A20Rkc46C8oxj0b
 yTElT4wt0PHeaTSliEC/SNGVmCHFp0PaFGd/jI6NODIH0QxAXE
 YW0QiUwzHgltvT9bZQOE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 June 2013, Leif Lindholm wrote:
> x86 and ia64 have the early_ioremap()/early_iounmap() functions, which are
> useful for supporting things like UEFI, ACPI and SMBIOS, where configuration
> tables need to be parsed before proper memory management is available,
> regardless of highmem status.
> 
> This patchset implements a restricted form of early_ioremap(), available
> before paging_init() only. Like the x86 code on which it is based, it
> (p)re-uses the fixmap regions for its virtual mapping range. Up to 7
> simultaneous mappings of up to 128KB can be accommodated in the available
> fixmap space.

+rmk

I made a similar suggestion to extending the use of fixmap recently, see
"Re: SCU registers mapping for CA9/CA5 cores". Russell pointed out that
fixmap is intentionally limited to just kmap_atomic uses at the moment
and changing that would potentially have a significant impact when we
run out of pages in the fixmap area.

The method we use on ARM normally is the iotable_init() function, which
requires hardcoding a virtual address at the moment.

It might be nicer to change that code than to put early_ioremap into
fixmap. Note that early_ioremap in fixmap is a bit of a kludge on x86
as well because it is very much /not/ a fixed mapping like the rest
of fixmap, they just use it because it's convenient.

Extending the iotable mechanism on ARM would be the convenient
solution for us I think.

	Arnd
