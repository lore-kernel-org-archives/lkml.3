Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaDOLgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:36:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51074 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaDOLgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140415111800.GW4963@mwanda>
References: <534c5757.VydWMxxcqkXGiwNa%akpm@linux-foundation.org>
	<CACVxJT-f+K_z-XxqjDVU_QK-VJPqnCEbWuMJF1fyTL0V0xiTgA@mail.gmail.com>
	<20140415111800.GW4963@mwanda>
Date: Tue, 15 Apr 2014 14:36:50 +0300
Message-ID: <CACVxJT91AH8gz6trGtU-eDF+nF5_KqtMj091Hu=RurzB1uFf4g@mail.gmail.com>
Subject: Re: + lib-stringc-strlcpy-might-read-too-far.patch added to -mm tree
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 2:18 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Apr 15, 2014 at 01:49:38PM +0300, Alexey Dobriyan wrote:
>> Return value matters. It may not matter for kernel, because kernel is
>> not heavy string user.
>> But it is better to not diverge from master code:
>> http://www.openbsd.org/cgi-bin/cvsweb/src/lib/libc/string/strlcpy.c?rev=1.11
>>
>
> Oh...  Hm.  Maybe we should drop this patch then.
>
>> Counter-rationale:
>> * strlcpy() accepts strings, so if you're giving raw buffer you're
>> doing it wrong.
>> * last byte of last page argument is bogus because kernel copies data
>> from userspace first.
>
> The last byte of the page argument seems possible:
>
>         foo = kmalloc();
>         copy_from_user(foo, arg, sizeof(foo));

Correct code would do
        foo->bar[sizeof(foo->bar)-1] = '\0';
if this field is a string.

>         strlcpy(dest.str, foo->bar, sizeof(dest.str));
