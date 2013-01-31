Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3AaV7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:59:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44534 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab3AaV7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:59:20 -0500
Message-ID: <510AE92B.8020605@zytor.com>
Date: Thu, 31 Jan 2013 13:59:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] rip out x86_32 NUMA remapping code
References: <20130131005616.1C79F411@kernel.stglabs.ibm.com> <510AE763.6090907@zytor.com> <CAE9FiQVn6_QZi3fNQ-JHYiR-7jeDJ5hT0SyT_+zVvfOj=PzF3w@mail.gmail.com>
In-Reply-To: <CAE9FiQVn6_QZi3fNQ-JHYiR-7jeDJ5hT0SyT_+zVvfOj=PzF3w@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 01:55 PM, Yinghai Lu wrote:
> On Thu, Jan 31, 2013 at 1:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I get a build failure on i386 allyesconfig with this patch:
>>
>> arch/x86/power/built-in.o: In function `swsusp_arch_resume':
>> (.text+0x14e4): undefined reference to `resume_map_numa_kva'
>>
>> It looks trivial to fix up; I assume resume_map_numa_kva() just goes
>> away like it does in the non-NUMA case, but it would be nice if you
>> could confirm that.
> 
> the patches does not seem to complete.
> 
> at least, it does not remove
> 
> arch/x86/mm/numa.c:     nd = alloc_remap(nid, nd_size);
> 

... which will just return NULL because alloc_remap turns into an inline
just returning NULL.  So the compiled code is correct, but the source
code is needlessly messy.

	-hpa

