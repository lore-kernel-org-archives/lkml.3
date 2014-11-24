Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaKXKlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:41:21 -0500
Received: from thoth.sbs.de ([192.35.17.2]:59331 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaKXKlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:41:20 -0500
Message-ID: <54730B33.1080101@siemens.com>
Date: Mon, 24 Nov 2014 11:40:51 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, nick <xerofoify@gmail.com>,
        gleb@kernel.org, Steven Rostedt <rostedt@goodmis.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Another Obsolete Fix me in trace.h?
References: <5472B5B5.5090201@gmail.com> <54730475.9040000@redhat.com>
In-Reply-To: <54730475.9040000@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-24 11:12, Paolo Bonzini wrote:
> On 24/11/2014 05:36, nick wrote:
>> Greetings Again Gleb and others,
>> I am assuming in the code I am pasting below the fix me is obsolete now and I can remove it. :)
>> Cheers Nick
>> TP_printk("%s (0x%x)",
>>                   __print_symbolic(__entry->exception, kvm_trace_sym_exc),
>>                    /* FIXME: don't print error_code if not present */
>>                   __entry->has_error ? __entry->error_code : 0)
>> );
>>
> 
> No, it's not obsolete, the idea is to print only
> 
>    %s
> 
> instead of
> 
>    %s (0x%x)
> 
> if __entry->has_error is false.  I don't know the trace API well enough
> to know if that is possible.

Last time I ran across such a scenario, it was not feasible and
essentially required separate tracepoints. But maybe Steven knows a trick.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
