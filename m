Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaHLTk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:40:57 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39588 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaHLTk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:40:56 -0400
MIME-Version: 1.0
In-Reply-To: <53EA6D24.3000609@codeaurora.org>
References: <1407867869-5194-1-git-send-email-keescook@chromium.org>
	<1407867869-5194-6-git-send-email-keescook@chromium.org>
	<53EA6D24.3000609@codeaurora.org>
Date: Tue, 12 Aug 2014 12:40:55 -0700
X-Google-Sender-Auth: YagIn7YISjbTo_HLFNidpLlB0wA
Message-ID: <CAGXu5jJiGXJQ4Bdu9Mhvj=jCdZ76w6_OOYoCmYEJZ47=HHSptg@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] arm: kgdb: Handle read-only text / modules
From: Kees Cook <keescook@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Liu hua <sdu.liu@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Doug Anderson <dianders@google.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Mark Salter <msalter@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 12:38 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 08/12/14 11:24, Kees Cook wrote:
>> @@ -244,6 +248,32 @@ void kgdb_arch_exit(void)
>>       unregister_die_notifier(&kgdb_notifier);
>>  }
>>
>> +int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
>> +{
>> +     int err;
>> +
>> +     /* patch_text() only supports int-sized breakpoints */
>> +     if (sizeof(int) != BREAK_INSTR_SIZE)
>> +             return -EINVAL;
>
> Could this be a BUILD_BUG_ON too?

Ah yes, good call. I'll adjust that.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
