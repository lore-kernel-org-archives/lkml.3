Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3AWQR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:17:58 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:62487 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab3AWQR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:17:57 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAFTL4hyBs=NNQ34SkVWAmfffWifR_v1DeXUKZmZo1bVyco3bpw@mail.gmail.com>
References: <1358957174-3927-1-git-send-email-sedat.dilek@gmail.com>
	<CAFTL4hyBs=NNQ34SkVWAmfffWifR_v1DeXUKZmZo1bVyco3bpw@mail.gmail.com>
Date: Wed, 23 Jan 2013 17:17:56 +0100
Message-ID: <CA+icZUWUxyU_cs949QROmpfRYMPA6F3Ebo0fJwM-DHaxOHLfLQ@mail.gmail.com>
Subject: Re: [PATCH 3.8-rc4-nohz3] kvm: Add missing include and EXPORT_SYMBOL_GPL
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 5:14 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
>> When CONFIG_KVM=m my build with 3.8-rc4-nohz3 breaks like this:
>>
>> ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!
>>
>> Fix this by removing the CONFIG_KVM ifdefs and adding missing
>> EXPORT_SYMBOL_GPL for:
>> + guest_enter() and guest_exit()
>> + vtime_guest_enter() and vtime_guest_exit()
>>
>> Also add a missing include:
>> + Add <linux/export.h> to kernel/context_tracking.c
>>
>> This issue was introduced with commit 8eebafe9be58 ("kvm: Prepare to
>> add generic guest entry/exit callbacks").
>>
>> With some help of funny "i™"X86 hackerz!
>>
>> Tested on a Ubuntu/precise AMD64 with 'CONFIG_KVM=m'.
>>
>> [ vUNKNOWN: Without the magic "i" hack. -dileks ]
>> [ vUNKNOWN+1: Remove vtime.h from kvm_host.h. -dileks ]
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> Thanks you!
>
> I hope you don't mind if I fold this patch into 8eebafe9be58. If I
> apply your patch separately, my patch would break the bisection.
> But I'll add your signed-off and the appropriate co-authorship credits.

That sounds reasonable! Thanks for the vital help... Enjoyed it :-).

- Sedat -
