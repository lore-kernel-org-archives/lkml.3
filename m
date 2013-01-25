Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3AYEQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 23:16:40 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48534 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3AYEQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 23:16:37 -0500
Message-ID: <510206CE.9050804@oracle.com>
Date: Thu, 24 Jan 2013 23:15:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, fweisbec@gmail.com,
        rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        jbaron@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        MartinSchwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH 2/5] jump label: constify lookup functions
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>  <1357772960-4436-2-git-send-email-sasha.levin@oracle.com> <1358544300.7383.37.camel@gandalf.local.home>
In-Reply-To: <1358544300.7383.37.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 04:25 PM, Steven Rostedt wrote:
> On Wed, 2013-01-09 at 18:09 -0500, Sasha Levin wrote:
>> Modify the parameters of all the lookup and the bookkeeping functions which
>> should be const to const.
>>
>> For example, jump_label_text_reserved() doesn't modify the memory it works on,
>> it just checks whether there are any jump labels there.
> 
> This is dependent on the module patch, which Rusty is taking. I need to
> see that he has it before this can go in. At least see it in linux-next.
> 
> Also, you should have Cc'd the linux-arch mailing list. I'll send it
> there.
> 
>>
>> Note I couldn't test the non-x86 architectures, but the changes are rather
>> trivial.
> 
> I ran it on 25 archs, and s390 hit:
> 
> /work/autotest/nobackup/cross-linux.git/arch/s390/kernel/jump_label.c: In function 'arch_jump_label_transform':
> /work/autotest/nobackup/cross-linux.git/arch/s390/kernel/jump_label.c:58:13: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]
> 
> -- Steve
> 
> Here's the patch:
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/arch/s390/kernel/jump_label.c
> b/arch/s390/kernel/jump_label.c
> index 85fa643..ef047ef 100644
> --- a/arch/s390/kernel/jump_label.c
> +++ b/arch/s390/kernel/jump_label.c
> @@ -18,7 +18,7 @@ struct insn {
>  } __packed;
>  
>  struct insn_args {
> -	struct jump_entry *entry;
> +	const struct jump_entry *entry;
>  	enum jump_label_type type;
>  };
>  

Sorry about this. I didn't have the ability to build all arches over here :(

Would you like me to resend this patch with your fix?


Thanks,
Sasha

