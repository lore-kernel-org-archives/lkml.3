Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab3IMN2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:28:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53411 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab3IMN1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:27:55 -0400
X-Nat-Received: from [202.181.97.72]:50583 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379078848.28724
To: waiman.long@hp.com
Cc: herbert@gondor.hengli.com.au, andr345@gmail.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, arthur.marsh@internode.on.net,
        tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
Subject: Re: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309121403.FIH09821.JtLOVOSFOFHFQM@I-love.SAKURA.ne.jp>
	<20130912052806.GA15737@gondor.apana.org.au>
	<201309121920.AHJ58678.OMVJFFSHOtOFQL@I-love.SAKURA.ne.jp>
	<20130912102953.GA18916@gondor.apana.org.au>
	<5231CF30.8050500@hp.com>
In-Reply-To: <5231CF30.8050500@hp.com>
Message-Id: <201309132227.JEB13098.SOLFHFOOVFJMQt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 13 Sep 2013 22:27:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 13092013 #11047731, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Waiman Long wrote:
> I would like to report that I also have the same boot problem on a 
> RHEL6.4 box with the crypto patch. My workaround is to force kernel 
> build to have the crc_t10dif code built-in by changing the config file:
> 
> 4889c4889
> < CONFIG_CRYPTO_CRCT10DIF=m
> ---
>  > CONFIG_CRYPTO_CRCT10DIF=y
> 5002c5002
> < CONFIG_CRC_T10DIF=m
> ---
>  > CONFIG_CRC_T10DIF=y
> 
> This solved the boot problem without any additional patch.  Do you think 
> you should consider changing the configuration default to "y" instead of 
> "m" or doesn't allow the "m" option at all?

That was proposed but not accepted.
https://lkml.org/lkml/2013/7/17/543

You should choose CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y in your kernel config
if your CPU supports PCLMULQDQ.
