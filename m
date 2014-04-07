Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaDGIEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:04:36 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:54650 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaDGIE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:04:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140406222737.GA26274@arm.com>
References: <1396707949-397-1-git-send-email-msalter@redhat.com>
	<20140406222737.GA26274@arm.com>
Date: Mon, 7 Apr 2014 10:04:28 +0200
Message-ID: <CAFrcx1kn+dMwMVrU1avLqe+PzQ6FvLSdVb7cf_uZF5_Pqw1yug@mail.gmail.com>
Subject: Re: [PATCH] arm64: fix !CONFIG_COMPAT build failures
From: Jean Pihet <jean.pihet@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 April 2014 00:27, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Sat, Apr 05, 2014 at 03:25:49PM +0100, Mark Salter wrote:
>> Recent arm64 builds using CONFIG_ARM64_64K_PAGES are failing with:
>>
>>   arch/arm64/kernel/perf_regs.c: In function 'perf_reg_abi':
>>   arch/arm64/kernel/perf_regs.c:41:2: error: implicit declaration of function 'is_compat_thread'
>>
>>   arch/arm64/kernel/perf_event.c:1398:2: error: unknown type name 'compat_uptr_t'
>>
>> This is due to some recent arm64 perf commits with compat support:
>>
>>   commit 23c7d70d55c6d9:
>>     ARM64: perf: add support for frame pointer unwinding in compat mode
>>
>>   commit 2ee0d7fd36a3f8:
>>     ARM64: perf: add support for perf registers API
>>
>> Those patches make the arm64 kernel unbuildable if CONFIG_COMPAT is not
>> defined and CONFIG_ARM64_64K_PAGES depends on !CONFIG_COMPAT. This patch
>> allows the arm64 kernel to build with and without CONFIG_COMPAT.
>>
>> Signed-off-by: Mark Salter <msalter@redhat.com>
>
> Thanks. Applied.
Thanks for tracking the problem!

Jean
>
> --
> Catalin
