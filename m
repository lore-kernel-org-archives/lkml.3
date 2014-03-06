Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbaCFCKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:10:30 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50388 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbaCFCK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:10:29 -0500
Message-ID: <5317D90B.3020606@linaro.org>
Date: Thu, 06 Mar 2014 11:10:19 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
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
Subject: Re: [PATCH v6 2/2] arm64: audit: Add audit hook in ptrace/syscall_trace
References: <1393319934-2810-1-git-send-email-takahiro.akashi@linaro.org> <1393564635-3921-1-git-send-email-takahiro.akashi@linaro.org> <1393564635-3921-3-git-send-email-takahiro.akashi@linaro.org> <20140228161558.GE29546@mudshark.cambridge.arm.com>
In-Reply-To: <20140228161558.GE29546@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2014 01:15 AM, Will Deacon wrote:
> On Fri, Feb 28, 2014 at 05:17:15AM +0000, AKASHI Takahiro wrote:
>> This patch adds auditing functions on entry to or exit from
>> every system call invocation.
>>
>> Acked-by: Richard Guy Briggs <rgb@redhat.com>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> ---
>>   arch/arm64/kernel/ptrace.c |   54 ++++++++++++++++++++++++++------------------
>>   1 file changed, 32 insertions(+), 22 deletions(-)
>
> I think you need to do something like I did for arch/arm/, where we have
> separate trace functions for entry/exit  to make sure that we invoke the
> various helpers in the correct order (for example, you want to invoke all
> the debug stuff *first* on entry, but *last* on exit).
>
> Will
>

If you mean syscall_trace_enter()/exit(), I will follow your suggestion
for readability.

-Takahiro AKASHI
