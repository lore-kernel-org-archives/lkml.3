Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaFJUZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:25:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35322 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbaFJUZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:25:01 -0400
Message-ID: <53976984.4030301@zytor.com>
Date: Tue, 10 Jun 2014 13:24:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>, Jiri Kosina <jkosina@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, jroedel@suse.de
Subject: Re: [PATCH] x86: be more helpful with SMEP faults
References: <alpine.LNX.2.00.1406102102030.1321@pobox.suse.cz> <20140610201823.GA29302@pd.tnic>
In-Reply-To: <20140610201823.GA29302@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 01:18 PM, Borislav Petkov wrote:
>>  static void
>>  show_fault_oops(struct pt_regs *regs, unsigned long error_code,
>> @@ -594,6 +596,11 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
>>  
>>  		if (pte && pte_present(*pte) && !pte_exec(*pte))
>>  			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
>> +		if (pte && pte_present(*pte) && pte_exec(*pte) &&
>> +				(pgd_flags(*pgd) & _PAGE_USER) &&
>> +				static_cpu_has(X86_FEATURE_SMEP) &&
> 
> Btw, we could probably save us this line as CR4 reserved bits should be
> Must-Be-Zero and setting any of those should #GP. And I'm talking about
> pre-SMEP Intel, and AMD machines.
> 
> IOW, if CR4.SMEP is set, it definitely means SMEP is present and
> enabled.
> 
> hpa, that true?
> 

Yes.  Also, the Linux kernel will set or clear X86_FEATURE_SMEP to
match, so the two are redundant.

	-hpa


