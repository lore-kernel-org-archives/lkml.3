Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaESOnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:43:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbaESOnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:43:45 -0400
Message-ID: <537A1889.8030801@redhat.com>
Date: Mon, 19 May 2014 15:43:21 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: mikey@neuling.org, avagin@openvz.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, michael@ellerman.id.au, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com> <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com> <537252C0.6090005@redhat.com> <53730326.6000400@linux.vnet.ibm.com> <53735044.5030008@redhat.com> <537479FD.2010200@linux.vnet.ibm.com> <5374AE24.1030302@redhat.com> <5379EF0E.6090504@linux.vnet.ibm.com>
In-Reply-To: <5379EF0E.6090504@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 12:46 PM, Anshuman Khandual wrote:

>> > I couldn't actually find any arch that currently returns -ENODEV in
>> > the "active" hook.  I see that binfmt_elf.c doesn't handle
>> > regset->active() returning < 0.  Guess that may be why.  Looks like
>> > something that could be cleaned up, to me.
>> >
> Also it does not consider the return value of regset->active(t->task, regset)
> (whose objective is to figure out whether we need to request regset->n number
> of elements or less than that) in the subsequent call to regset->get function.

Indeed.

TBC, do you plan on fixing this?  Otherwise ...

> Now coming to the installation of the .active hooks part for all the new regsets, it
> should be pretty straight forward as well. Though its optional and used for elf_core_dump
> purpose only, its worth adding them here. Example of an active function should be something
> like this. The function is inexpensive as required.
> 
> +static int tm_spr_active(struct task_struct *target,
> +                               const struct user_regset *regset)
> +{
> +       if (!cpu_has_feature(CPU_FTR_TM))
> +               return -ENODEV;

... unfortunately this will do the wrong thing.

Thanks,
-- 
Pedro Alves

