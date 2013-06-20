Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab3FTRkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:40:20 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:44524 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab3FTRkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <87fvwirdej.fsf@rustcorp.com.au>
References: <1371258778-12655-1-git-send-email-minipli@googlemail.com>
	<87fvwirdej.fsf@rustcorp.com.au>
Date: Thu, 20 Jun 2013 19:40:16 +0200
Message-ID: <CA+rthh_J4LMnJLQt6qnQ=ieUD7CpBZBOMsthMMpOb-BkokQggQ@mail.gmail.com>
Subject: Re: [PATCH v2] module: don't modify argument of module_kallsyms_lookup_name()
From: Mathias Krause <minipli@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2013 04:35, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Mathias Krause <minipli@googlemail.com> writes:
>> If we pass a pointer to a const string in the form "module:symbol"
>> module_kallsyms_lookup_name() will try to split the string at the colon,
>> i.e., will try to modify r/o data. That will, in fact, fail on a kernel
>> with enabled CONFIG_DEBUG_RODATA.
>>
>> Avoid modifying the passed string in module_kallsyms_lookup_name(),
>> modify find_module_all() instead to pass it the module name length.
>>
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>
> Applied, thanks.

Mind to push it to
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git#modules-next
as well, so it'll be included in linux-next?

Thanks,
Mathias
