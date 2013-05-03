Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763097Ab3ECP32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:29:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58934 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079Ab3ECP31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:29:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Chanho Min" <chanho.min@lge.com>
Subject: Re: Re : [PATCH, RFC 09/22] crypto: lz4: don't build on ARM
Date: Fri, 3 May 2013 17:29:17 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <OF54831661.2286D403-ON49257B5F.00831E7A-49257B5F.00831E7D@lge.com>
In-Reply-To: <OF54831661.2286D403-ON49257B5F.00831E7A-49257B5F.00831E7D@lge.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305031729.17360.arnd@arndb.de>
X-Provags-ID: V02:K0:yAAg7w+3E0RRssWtvxurnzT020EgVsObxSiKyY1lrRo
 wzLK7PvLI0GVDjIvarkB94b34r5ukv4+8+tF7Ry4sLkQ4/80Rw
 euCQZYU4ULVRhTz4VQMSiyyL2cDGshMGJ1HRMCghyRc/aISsmi
 TKbpBgWiGfhgQlLTeLOwc3DMoT1OK8Av+dQPOAQBhQtb2nadMo
 8fBr2LyaP3gD7I2RFdLRyBD6XgOGRzGM7Rdq6t0oaSC71AaqZF
 ffPkmdJdVwbjdAIgKygHk8ApgAhNJWYUv3/ZFbYIaYj67A176Z
 H3EaaWsZ6ud7Pd/98mvhcEyP7NSExb/e87h0jtKGS6WvoannVb
 fBeRJGwmkt/c5QAyZNDo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 May 2013, Chanho Min wrote:
> >It is not currently possible to build the LZ4 code on ARM, so let's
> >remove that option in Kconfig for now.
> >
> >lib/built-in.o: In function `lz4_compress64kctx':
> > lib/lz4/lz4_compress.c:339: undefined reference to `__ctzsi2'
> >lib/built-in.o: In function `lz4_compressctx':
> > lib/lz4/lz4_compress.c:157: undefined reference to `__ctzsi2'
> >lib/built-in.o: In function `lz4hc_commonlength':
> > lib/lz4/lz4hc_compress.c:102: undefined reference to `__ctzsi2'
> > lib/lz4/lz4hc_compress.c:102: undefined reference to `__ctzsi2'
> >lib/built-in.o: In function `lz4hc_insertandgetwidermatch':
> > lib/lz4/lz4hc_compress.c:230: undefined reference to `__ctzsi2'
> 
> Please, let me know the gcc version and tested defconfig.
> I didn't have any problem to build with gcc 4.6.4 on armv7.
> Some architecture need libgcc functions for __builtin_clz/ctz.
> Porting them to lib is in progress:
> http://marc.info/?l=linux-kernel&amp;m=136748861811956&amp;w=2
> But, It doesn't happen on ARM, PowerPC and x86.

I tested with gcc-4.8 and random configurations. I've tried it
again now and can't reproduce it at the moment. I'll try building
more random configurations until I have nailed down the problem.

Sorry about this, I should have been more careful about my
original conclusion here.

	Arnd
