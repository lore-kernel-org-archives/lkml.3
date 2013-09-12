Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3ILO1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:27:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:4326 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3ILO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:27:10 -0400
Message-ID: <5231CF30.8050500@hp.com>
Date: Thu, 12 Sep 2013 10:26:56 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, andr345@gmail.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        arthur.marsh@internode.on.net, tim.c.chen@linux.intel.com,
        linux-crypto@vger.kernel.org
Subject: Re: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
References: <201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp> <201309112043.HBD04609.FOtLSOFVQHFOJM@I-love.SAKURA.ne.jp> <20130912042622.GA15181@gondor.apana.org.au> <201309121403.FIH09821.JtLOVOSFOFHFQM@I-love.SAKURA.ne.jp> <20130912052806.GA15737@gondor.apana.org.au> <201309121920.AHJ58678.OMVJFFSHOtOFQL@I-love.SAKURA.ne.jp> <20130912102953.GA18916@gondor.apana.org.au>
In-Reply-To: <20130912102953.GA18916@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 06:29 AM, Herbert Xu wrote:
> On Thu, Sep 12, 2013 at 07:20:23PM +0900, Tetsuo Handa wrote:
>> Herbert Xu wrote:
>>> The trouble is not all distros will include the softdep modules in
>>> the initramfs.  So for now I think we will have to live with a fallback.
>> I see.
>>
>> Herbert Xu wrote:
>>> OK, can you please try this patch on top of the current tree?
>>>
>>> This way at least you'll have a working system until your initramfs
>>> tool is fixed to do the right thing.
>> I tested the patch and confirmed that the boot failure was solved.
>>
>> But arch/x86/crypto/crct10dif-pclmul.ko is not included into initramfs and
>> therefore we cannot benefit from PCLMULQDQ version.
> That is expected and is also the status quo.  So once the initrd
> generation tool is fixed to include softdeps it will work properly.
>
> Thanks!

I would like to report that I also have the same boot problem on a 
RHEL6.4 box with the crypto patch. My workaround is to force kernel 
build to have the crc_t10dif code built-in by changing the config file:

4889c4889
< CONFIG_CRYPTO_CRCT10DIF=m
---
 > CONFIG_CRYPTO_CRCT10DIF=y
5002c5002
< CONFIG_CRC_T10DIF=m
---
 > CONFIG_CRC_T10DIF=y

This solved the boot problem without any additional patch.  Do you think 
you should consider changing the configuration default to "y" instead of 
"m" or doesn't allow the "m" option at all?

Thanks!
