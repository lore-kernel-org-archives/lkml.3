Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaDQPpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:45:38 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44218 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDQPpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:45:32 -0400
X-Auth-Info: K38PvGuHoZRkfv7UMl09ImzXbJ3s2fXBUyeUEPMSnQs=
From: Marek Vasut <marex@denx.de>
To: Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH] crypto: sha{256,512}_ssse3 - remove asmlinkage from static functions
Date: Thu, 17 Apr 2014 17:28:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1397665190-12491-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1397665190-12491-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201404171728.41994.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 16, 2014 at 06:19:50 PM, Jianyu Zhan wrote:
> Commit 128ea04a9885("lto: Make asmlinkage __visible") restricts
> asmlinkage to externally_visible, this causes compilation warnings:
> 
>     arch/x86/crypto/sha256_ssse3_glue.c:56:1:
>     warning: ‘externally_visible’ attribute have effect only on public
> objects [-Wattributes]
> 
>     static asmlinkage void (*sha256_transform_asm)(const char *, u32 *,
> u64); ^
> 
>     arch/x86/crypto/sha512_ssse3_glue.c:55:1:
>     warning: ‘externally_visible’ attribute have effect only on public
> objects [-Wattributes] static asmlinkage void
> (*sha512_transform_asm)(const char *, u64 *, ^
> 
> Drop asmlinkage here to avoid such warnings.
> 
> Also see Commit 8783dd3a37a5853689e1("irqchip: Remove asmlinkage from
> static functions")
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Makes sense, please add my humble

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
