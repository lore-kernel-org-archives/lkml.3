Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3ANFqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:46:20 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:54706 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3ANFqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:46:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130113125653.GA17200@liondog.tnic>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-22-git-send-email-yinghai@kernel.org>
	<20130113125653.GA17200@liondog.tnic>
Date: Sun, 13 Jan 2013 21:46:17 -0800
X-Google-Sender-Auth: XEzqJfD5N2Qa9MHNVUWCTxxnHL0
Message-ID: <CAE9FiQXve8SnpzC4i212SaU5j6HtNWiMNnaQhfnjfG4UzXDJYQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 21/31] x86, kexec: only set ident mapping for ram.
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 4:56 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 03, 2013 at 04:48:41PM -0800, Yinghai Lu wrote:
>> We should not set mapping for all under max_pfn.
>
> "We should not establish mappings for all memory under max_pfn."

that is not accurate.

We should not set mapping for all range under max_pfn.

or

We should set mappings only for memory ranges under max_pfn.

>
>> That causes same problem that is fixed by
>
> "Otherwise, it causes the same ..."
>
>>
>>       x86, mm: Only direct map addresses that are marked as E820_RAM
>
> You could add this patch's commit id since it is in tip:x86/mm2 and it
> shouldn't change: 66520ebc2df3.

why ? they are not in linus tree yet, so it could change if that tip
branch is rebased.

>
> Ditto for patch 09/31, "x86, 64bit: #PF handler set page to cover 2M only".


>
>>
>> This patch expose pfn_mapped array, and only set ident mapping for ranges
>
>              exposes the...                    sets
>
>> in that array.
>>
>> This patch rely on new ident_mapping_init that could handle existing
>
>              relies on the new
>
>> pgd/pud between different calling.
>
>                             calls.
>

ok, fix those problems
