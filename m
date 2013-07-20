Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3GTCU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 22:20:56 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50210 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3GTCUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 22:20:54 -0400
X-Nat-Received: from [202.181.97.72]:54943 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1374286761.22981
To: tim.c.chen@linux.intel.com, herbert@gondor.hengli.com.au
Cc: hpa@zytor.com, gregkh@linuxfoundation.org, rjw@rjwysocki.net,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to moduledependency.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130719231630.GC1701@kroah.com>
	<51E9C9E5.2060602@zytor.com>
	<20130719232459.GA18039@gondor.apana.org.au>
	<1374277033.22432.384.camel@schen9-DESK>
	<1374283864.22432.393.camel@schen9-DESK>
In-Reply-To: <1374283864.22432.393.camel@schen9-DESK>
Message-Id: <201307201119.FHF34361.FLFOJHFQVSOOMt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 20 Jul 2013 11:19:17 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 19072013 #10634072, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> On Fri, 2013-07-19 at 16:37 -0700, Tim Chen wrote:
> > Herbert,
> > 
> > I've tried the module alias approach (see my earlier mail with patch) 
> > but it didn't seem to load things properly.  Can you check to see if 
> > there's anything I did incorrectly.
> > 
> > Tim
> 
> I fixed a missing request_module statement in crct10dif library.  
> So now things work if I have the following config:
> 
> CONFIG_CRYPTO_CRCT10DIF=m
> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
> CONFIG_CRC_T10DIF=m
> 
> However, when I have the library and generic algorithm compiled in,
> I do not see the PCLMULQDQ version loaded.
> 
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
> CONFIG_CRC_T10DIF=y
> 
> Perhaps I am initiating the crct10dif library at a really early
> stage when things are compiled in, where the module is not in 
> initramfs?  In that case, perhaps we should only allow 
> PCLMUL version to be compiled in
> and not exist as a module?

I think that use of request_module("crct10dif") does not help loading
crct10dif-pclmul.ko when CONFIG_CRC_T10DIF=y CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m ,
for there is no / directory (note that the initramfs is not yet mounted as /
for loading modules which are not in vmlinux) when any module_init() functions
which are in vmlinux are called.
