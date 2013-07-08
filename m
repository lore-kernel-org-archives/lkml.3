Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3GHXEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 19:04:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3GHXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 19:04:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v3 4/4] ARM: reinsert ARCH_MULTI_V4 Kconfig option
Date: Tue, 9 Jul 2013 01:03:27 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        arm@kernel.org, olof@lixom.net
References: <1372949142-8260-1-git-send-email-jonas.jensen@gmail.com> <CACmBeS3Ges44HxOGZns+G=jQhSmGjVmZBir2_ZBXT1i2nrNQwg@mail.gmail.com>
In-Reply-To: <CACmBeS3Ges44HxOGZns+G=jQhSmGjVmZBir2_ZBXT1i2nrNQwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307090103.27296.arnd@arndb.de>
X-Provags-ID: V02:K0:5tiH/ZIVFrY3CSyhOJvRbxqZloyDQsf98IAvNImLZEA
 w7z1daQsbZIkr4TnXLD+0QZOMRVfUztinSiGZIgGnjpweLgOMD
 +CJBANswY4eq3Fe1Ae8ZygijTx328wpL6dwCuDwYfdqoq6aw0q
 nnmCkiye3VyOaENtLV6JT+wEHqt2Xw77VdV7dTuQNwVzACOPkL
 5cFWRtDDiIFZ4406FQUeUAYSVoOiwurkjIPNkOsYDDGmRAGheO
 XLhKMZG85ervk6F305ur6i57PFhNrC5HPj2slBFi/jB3vuVWNO
 u2WykpOvsdD+p1A/MtOaGREYF9g84uqca2jPf4i5WZvku3kzrk
 kavBD6/20wdTk2KX4TEY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 July 2013, Jonas Jensen wrote:
> Arnd suggested removing one (or many) of the options:
> 
> CPU_ABRT_EV4T
> CPU_CACHE_V4WT
> CPU_COPY_V4WB
> CPU_TLB_V4WBI
> 
> However boot is still broken after removing all including CPU_32v4T.
> 
> Selecting CPU_SA1100 instead, it boots normally and init works.
> 
> The idea is, If you can help figure out what exactly breaks boot, the
> patch can be dropped.
> 
> From these tests, I have created two branches ( arch/arm/mm have
> replacements for calls to no longer compiled in ):
> 
> http://code.google.com/p/linux-next-20130703-moxart/source/detail?r=a88f33ad22d3f9a31fe126f1c95568e5b2e8f32d&name=multi_V4_test_arm920t
> http://code.google.com/p/linux-next-20130703-moxart/source/detail?r=9f4c21f1123a122c51792cd374217ce6e426e74a&name=multi_V4_test_sa1100

It looks like you select CPU_ARM926T but change the entry for CPU_ARM920T
instead, which would have no effect then.

	Arnd
