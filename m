Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaDREuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 00:50:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34729 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaDREuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 00:50:35 -0400
Message-ID: <5350AEF4.9060905@zytor.com>
Date: Thu, 17 Apr 2014 21:49:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>, Jianyu Zhan <nasa4836@gmail.com>
CC: herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sha{256,512}_ssse3 - remove asmlinkage from static
 functions
References: <1397665190-12491-1-git-send-email-nasa4836@gmail.com> <201404171728.41994.marex@denx.de>
In-Reply-To: <201404171728.41994.marex@denx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 08:28 AM, Marek Vasut wrote:
> On Wednesday, April 16, 2014 at 06:19:50 PM, Jianyu Zhan wrote:
>> Commit 128ea04a9885("lto: Make asmlinkage __visible") restricts
>> asmlinkage to externally_visible, this causes compilation warnings:
>>
>>     arch/x86/crypto/sha256_ssse3_glue.c:56:1:
>>     warning: ‘externally_visible’ attribute have effect only on public
>> objects [-Wattributes]
>>
>>     static asmlinkage void (*sha256_transform_asm)(const char *, u32 *,
>> u64); ^
>>
>>     arch/x86/crypto/sha512_ssse3_glue.c:55:1:
>>     warning: ‘externally_visible’ attribute have effect only on public
>> objects [-Wattributes] static asmlinkage void
>> (*sha512_transform_asm)(const char *, u64 *, ^
>>
>> Drop asmlinkage here to avoid such warnings.
>>
>> Also see Commit 8783dd3a37a5853689e1("irqchip: Remove asmlinkage from
>> static functions")
>>
>> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> 
> Makes sense, please add my humble
> 
> Reviewed-by: Marek Vasut <marex@denx.de>
> 

It doesn't make sense, sorry.  The right thing to drop here is not
"asmlinkage", it is "static": this is an external declaration.

	-hpa


