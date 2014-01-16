Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaAPOla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:41:30 -0500
Received: from mail1.windriver.com ([147.11.146.13]:37534 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaAPOl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:41:28 -0500
Message-ID: <52D7EF99.4010803@windriver.com>
Date: Thu, 16 Jan 2014 09:41:29 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "x86: fix 27-rc crash on vsmp due to paravirt
 during module load"
References: <1389838259-29411-1-git-send-email-paul.gortmaker@windriver.com> <20140116084458.GA9346@gmail.com>
In-Reply-To: <20140116084458.GA9346@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-16 03:44 AM, Ingo Molnar wrote:
> 
> * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
>> This reverts commit 05e12e1c4c09cd35ac9f4e6af1e42b0036375d72.
>>
>> The old change from __init --> __init_or_module doesn't make
>> sense anymore, given that the arch/x86/kernel/vsmp_64.c code
>> is only for non-modular builds.
>>
>> As of commit 70511134f61bd6e5eed19f767381f9fb3e762d49
>> ("Revert "x86: don't compile vsmp_64 for 32bit") this file
>> became obj-y and hence is only for built-in.  That makes
>> any "or_module" support redundant.
>>
>> We need to distinguish between the two in order to do some
>> header cleanups.  This revert starts that process.
>>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> I suspect you want to carry this as part of your header cleanups, to 
> not have to wait for upstream propagation?

Either way is fine; I've already fed out some of the other
independent chunks to maintainers just to keep the size of
what goes in from me at rc1 a bit smaller.

> 
> Please fix the title: the original commit was right, but was mooted by 
> other changes. That's not a revert but a change that happens to be the 
> inverse of an earlier change.

Fair point; will fix.

Thanks,
Paul.
--

> 
> Thanks,
> 
> 	Ingo
> 
