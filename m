Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3HLX7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:59:04 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33975 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3HLX7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:59:01 -0400
MIME-Version: 1.0
In-Reply-To: <520974DC.60802@intel.com>
References: <1376351004-4015-1-git-send-email-yinghai@kernel.org>
	<520974DC.60802@intel.com>
Date: Mon, 12 Aug 2013 16:59:00 -0700
X-Google-Sender-Auth: lMPsj8wtXK4RDa9KAFpjFteml-8
Message-ID: <CAE9FiQXZ5qgsiyat_KYArJnEdi1O_q3ybdSHj3OehmEK+GG4hg@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix booting with DEBUG_PAGE_ALLOC with more than
 512G RAM
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 4:50 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 08/12/2013 04:43 PM, Yinghai Lu wrote:
>>> > commit 8170e6bed465b4b0c7687f93e9948aca4358a33b
>>> > Author: H. Peter Anvin <hpa@zytor.com>
>>> > Date:   Thu Jan 24 12:19:52 2013 -0800
>>> >
>>> >     x86, 64bit: Use a #PF handler to materialize early mappings on demand
>> Before that, we have maping from [0,512M) in head_64.S, and we can
>> spare two pages [0-1M).  After that change, we can not reuse pages anymore.
>>
>> When we have more than 512M ram, we need extra page for pgd page with
>> [512G, 1024g).
>>
>> Increase pages in BRK for page table to solve the booting problem.
>
> So how much does this get us up to?  1TB?  That's actually _fairly_
> small today.  I've got a fairly old machine with that much in it, and
> it's only half full of DIMMs.
>
> It's also a bit worrying that this is completely disconnected from the
> other code in the kernel that is concerned with the amount of total
> address space in the system: MAX_PHYSADDR_BITS.

3 pages for [0,1M)
3 pages for initial 2M. ( it is 2M alignment).
are enough.

one page for PGD page (cover 512g), one page for PUD page (cover 1G)
and one page for PMD page (cover 2M).

After initial 2M is mapped, we will use that mapped 2M for other
memory range page table buffer.

Thanks

Yinghai
