Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaI2HAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 03:00:01 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:35759 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI2HAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 03:00:00 -0400
MIME-Version: 1.0
In-Reply-To: <5425A008.2030901@arm.com>
References: <1411750918-25220-1-git-send-email-will.deacon@arm.com>
	<5425A008.2030901@arm.com>
Date: Mon, 29 Sep 2014 08:59:59 +0200
Message-ID: <CAFrcx1=s4Ae2z6OAC3dUR34rhd=HpKA+O9DAtM=QVNpJ7oNnEg@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix build breakage on arm and arm64 targets
From: Jean Pihet <jean.pihet@linaro.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, "acme@redhat.com" <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 26 September 2014 19:19, Sudeep Holla <sudeep.holla@arm.com> wrote:
>
> On 26/09/14 18:01, Will Deacon wrote:
>>
>> Attempting to build the perf tool on arm or arm64 targets results in the
>> following failure:
>>
>> arch/arm/util/unwind-libunwind.c: In function ‘libunwind__arch_reg_id’:
>> arch/arm/util/unwind-libunwind.c:43:3: error: implicit declaration of
>> function ‘pr_err’ [-Werror=implicit-function-declaration]
>>     pr_err("unwind: invalid reg id %d\n", regnum);
>>     ^
>> This is due to commit 84f5d36f4866 ("perf tools: Move pr_* debug macros
>> into debug object") moving the pr_* macros into a new header file, but
>> failing to update architectures other than x86.
>>
>> This patch adds the missing includes, and fixes the build again.

The fix for ARM is already in the tip tree at
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=29a3ce31c38c8f73f4e076b7ffc0876b4f5dd6c3.

Regards,
Jean

>>
>
> For ARM64, we also need the patch[1] "perf tools: Fix arm64 build error"
> which is already queued in linux-next.
>
> Regards,
> Sudeep
>
> [1] https://lkml.org/lkml/2014/6/24/1024
>
