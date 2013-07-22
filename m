Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab3GVKLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:11:12 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41688 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab3GVKLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:11:11 -0400
Message-ID: <51ED053C.1070105@hitachi.com>
Date: Mon, 22 Jul 2013 19:11:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>
Subject: Re: [PATCH -tip 3/3] x86: Remove unused text_poke_smp and text_poke_smp_batch
References: <20130718114738.26675.85914.stgit@mhiramat-M0-7522> <20130718114753.26675.18714.stgit@mhiramat-M0-7522> <20130722074339.GA25976@gmail.com> <20130722082104.GA26823@gmail.com> <51ECEF8D.60109@hitachi.com> <20130722100158.GB908@gmail.com>
In-Reply-To: <20130722100158.GB908@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/22 19:01), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2013/07/22 17:21), Ingo Molnar wrote:
>>>
>>> * Ingo Molnar <mingo@kernel.org> wrote:
>>>
>>>>
>>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>
>>>>> Since introducing the text_poke_bp for all text_poke_smp*
>>>>> callers, text_poke_smp* are now unused. This basically
>>>>> reverts 3d55cc8a, 7deb18dc and related commits.
>>>>>
>>>>> This also fixes a Kconfig dependency issue on STOP_MACHINE
>>>>> in the case of CONFIG_SMP && !CONFIG_MODULE_UNLOAD.
>>>>>
>>>>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>>>> ---
>>>>>  arch/x86/Kconfig                   |    5 --
>>>>>  arch/x86/include/asm/alternative.h |   11 ----
>>>>>  arch/x86/kernel/alternative.c      |   98 +-----------------------------------
>>>>>  3 files changed, 2 insertions(+), 112 deletions(-)
>>>>
>>>> Hm, it does not build with the attached config:
>>>>
>>>> arch/x86/kernel/kprobes/opt.c: In function 'setup_optimize_kprobe':
>>>> arch/x86/kernel/kprobes/opt.c:394:6: error: dereferencing pointer to incomplete type
>>>> arch/x86/kernel/kprobes/opt.c:395:6: error: dereferencing pointer to incomplete type
>>>> arch/x86/kernel/kprobes/opt.c:396:6: error: dereferencing pointer to incomplete type
>>>
>>> 32-bit appears to be the key pattern.
>>
>> Ingo, please make sure your x86/jumplabel tree picked all of my patches.
>> This 3/3 strongly depends on the previous 1/3 and 2/3.
>> Without it, kprobes/opt.c can not be build because it still uses the
>> text_poke_params data structure which 3/3 removes.
> 
> Yes I know, and it was on top of -tip which already had these included:
> 
>  51b2c07b2226 x86: Make jump_label use int3-based patching
>  fd4363fff3d9 x86: Introduce int3 (breakpoint)-based instruction patching
> 
> without these the third patch wouldn't even apply I think.

No, I meant below two patches:
 kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
 kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()

Since the "setup_optimize_kprobe" in the error message is completely
*removed* by the second one, the above error should not happen.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


