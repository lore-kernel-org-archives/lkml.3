Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbbAMQ6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:58:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbbAMQ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:58:03 -0500
Message-ID: <54B54E85.9020601@redhat.com>
Date: Tue, 13 Jan 2015 11:57:41 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 05/11] x86,fpu: ensure FPU state is reloaded from
 memory if task is traced
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-6-git-send-email-riel@redhat.com> <20150113161938.GA24447@redhat.com> <54B548EA.7020005@redhat.com> <20150113165043.GA26931@redhat.com>
In-Reply-To: <20150113165043.GA26931@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2015 11:50 AM, Oleg Nesterov wrote:
> On 01/13, Rik van Riel wrote:
>> 
>>>> @@ -412,8 +412,14 @@ static inline void
>>>> switch_fpu_prepare(struct task_struct *old, struct task_struc
>>>> bool preload = tsk_used_math(new) && (use_eager_fpu() ||
>>>> new->thread.fpu_counter
>>>>> 5); if (__thread_has_fpu(old)) { -		if
>>>>> (!__save_init_fpu(old))
>>>> +		/* +		 * Make sure the FPU state is restored from memory
>>>> next time, +		 * if the task has an FPU exception pending, or
>>>> the task's in +		 * memory FPU state could be changed by a
>>>> debugger. +		 */ +		if (!__save_init_fpu(old) || 
>>>> task_is_stopped_or_traced(old)) cpu = ~0;
>>> 
>>> Well, if debugger wants to change FPU state, it should call 
>>> init_fpu() which resets .last_cpu ?
>> 
>> Does the ptrace (and utrace, and ... ) code actually do that?
> 
> Yes, see xfpregs_get/set. So I think this change is not needed (but
> I didn't look at the next patches).

Excellent, I will drop this then.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtU6FAAoJEM553pKExN6Dn1YH/0zWFvPtmbSWPez8EfsnHJe9
dF0h0kUHMKb1bUFNyqrQpmX1MuBHba9ab4a1P8ySoC9nIo8F7spSX+OG/CigDZzZ
vguz9J/MFrjhW83+eeyVc5PLwtVWwiYzbGB+Xc8ValMqHPT8m6kG2H+hw6ItRtnR
UwoPeQn27WjdaVT9/L13uYA8i6vwqD6pO68PzBs3xSFXbt0FHl9T0jaZ5O0WIzav
b7bNQ/HFpCZSqjqmc4KxlavBFlC8Ku9rMTYRzWXYtdjwfcn8rDTKpDZz7uBSd+Gl
bwb0u1rYcQnYQrJVmrarMEoySSfYAp6WsTIl7G/zWfJDSmPOYHLdurimoC14vgA=
=fxF+
-----END PGP SIGNATURE-----
