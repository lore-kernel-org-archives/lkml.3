Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaD1J6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:58:45 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46827 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaD1J6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:58:43 -0400
Message-ID: <535E264B.7050806@linaro.org>
Date: Mon, 28 Apr 2014 18:58:35 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH v5 2/4] arm64: split syscall_trace() into separate functions
 for enter/exit
References: <1394705491-12343-1-git-send-email-takahiro.akashi@linaro.org> <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org> <1394861948-28712-3-git-send-email-takahiro.akashi@linaro.org> <20140416132716.GA1001@arm.com>
In-Reply-To: <20140416132716.GA1001@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 10:27 PM, Will Deacon wrote:
> Hi Akashi,
>
> On Sat, Mar 15, 2014 at 05:39:06AM +0000, AKASHI Takahiro wrote:
>> As done in arm, this change makes it easy to confirm we invoke syscall
>> related hooks, including syscall tracepoint, audit and seccomp which would
>> be implemented later, in correct order. That is, undoing operations in the
>> opposite order on exit that they were done on entry.
>>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>
> [...]
>
>> +static void tracehook_report_syscall(struct pt_regs *regs,
>> +				     enum ptrace_syscall_dir dir)
>>   {
>> +	int scrach;
>
> s/scrach/scratch/

I will fix it.

> Although, I'd rather have a variable with a more meaningful name. How about
> regno?

OK, I will use regno in the next revision, which I will submit soon.

> With that,
>
>    Acked-by: Will Deacon <will.deacon@arm.com>

Thank you so much,
-Takahiro AKASHI

> Cheers,
>
> Will
>
