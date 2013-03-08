Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496Ab3CHRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:25:57 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:50883 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab3CHRZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:25:56 -0500
MIME-Version: 1.0
In-Reply-To: <51399F34.2030500@cn.fujitsu.com>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-15-git-send-email-yinghai@kernel.org>
	<51399F34.2030500@cn.fujitsu.com>
Date: Fri, 8 Mar 2013 09:25:55 -0800
X-Google-Sender-Auth: Oza00ux_sTFgYHtY4oShVSiySVs
Message-ID: <CAE9FiQV5bsHdYGk6p3fBzNyFk8ffswdKqCreidh7+z1Cn3+++g@mail.gmail.com>
Subject: Re: [PATCH 14/14] x86, mm: Put pagetable on local node ram
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 12:20 AM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> Hi Yinghai,
>
> On 03/08/2013 12:58 PM, Yinghai Lu wrote:
> ......
>
>>         /* xen has big range in reserved near end of ram, skip it at
>> first.*/
>> -       addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE,
>> PMD_SIZE);
>> +       addr = memblock_find_in_range(begin, end, PMD_SIZE, PMD_SIZE);
>
>
> Found that the latest code here is:
>
>  414         addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE,
>  415                          PAGE_SIZE);
>                              ^^^^^^^^^^^^
>
> The "align" is PAGE_SIZE, not PMD_SIZE. Not sure if it is a problem. :)
>

Yes, it is PMD_SIZE.

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=98e7a989979b185f49e86ddaed2ad6890299d9f0

Thanks

Yinghai
