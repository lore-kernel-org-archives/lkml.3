Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3IZCrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:47:47 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45249 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3IZCrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:47:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130925111605.7437f70f@gandalf.local.home>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
	<1380105868-31985-3-git-send-email-liuj97@gmail.com>
	<20130925103535.2249f617@gandalf.local.home>
	<CA+b37P0P0RhUytnkLSXmz28wzzsoL3-viV2oxNJqq2nP7kZBFA@mail.gmail.com>
	<20130925111605.7437f70f@gandalf.local.home>
Date: Thu, 26 Sep 2013 08:17:45 +0530
Message-ID: <CA+b37P2yQOo8X1jyPC-QxRbJ1EHL7U06hC_26Gn0SnhMhJKCuA@mail.gmail.com>
Subject: Re: [PATCH v1 2/7] arm64: introduce interfaces to hotpatch kernel and
 module code
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiang Liu <liuj97@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2013 20:46, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 25 Sep 2013 20:12:17 +0530
> Sandeepa Prabhu <sandeepa.prabhu@linaro.org> wrote:
>
>
>> > On aarch64, are instructions always word aligned? If not, it should be
>> > safe for stop machine to modify non word aligned instructions, but this
>> > patch looks like it doesn't allow stop_machine() to do so.
>> Steve,
>>
>> Yes, aarch64 instructions must be word-aligned, else instruction fetch
>> would generate Misaligned PC fault.
>>
>
> Thanks for clarifying, as IIUC, there's ARM architectures that allow
> for 2 and 4 byte instructions.
Yes, ARM 32-bit mode would support both 32-bit and 16-bit alignment
based on ARM or Thumb mode, whereas
AArch64 (in arch/arm64/) is always 32-bit instructions and PC need to
be aligned to 32-bit address.

Thanks,
Sandeepa
>
> -- Steve
