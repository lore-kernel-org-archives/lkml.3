Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3ANSRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:17:30 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36889 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab3ANSR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:17:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130114095314.GE1228@liondog.tnic>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-22-git-send-email-yinghai@kernel.org>
	<20130113125653.GA17200@liondog.tnic>
	<CAE9FiQXve8SnpzC4i212SaU5j6HtNWiMNnaQhfnjfG4UzXDJYQ@mail.gmail.com>
	<20130114095314.GE1228@liondog.tnic>
Date: Mon, 14 Jan 2013 10:17:27 -0800
X-Google-Sender-Auth: ngirWmUDlse-r-y_aI_HEerqUsI
Message-ID: <CAE9FiQWkoFN-hkgyBpcQUL6zEjuAquMPO2-9fgSekc_4ZHeP4Q@mail.gmail.com>
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

On Mon, Jan 14, 2013 at 1:53 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Jan 13, 2013 at 09:46:17PM -0800, Yinghai Lu wrote:
>> On Sun, Jan 13, 2013 at 4:56 AM, Borislav Petkov <bp@alien8.de> wrote:
>> > On Thu, Jan 03, 2013 at 04:48:41PM -0800, Yinghai Lu wrote:
>> >> We should not set mapping for all under max_pfn.
>> >
>> > "We should not establish mappings for all memory under max_pfn."
>>
>> that is not accurate.
>>
>> We should not set mapping for all range under max_pfn.
>>
>> or
>>
>> We should set mappings only for memory ranges under max_pfn.
>
> Ok, that last thing is getting close. So do I understand it correctly
> now:
>
> "We should establish mappings only for memory (memory which is not
> marked reserved or whatever by E820 or some other mechanism) under
> max_pfn."
>
> ?

yes, you got it.

---
We should set mappings only for usable memory ranges under max_pfn
Otherwise causes same problem that is fixed by

        x86, mm: Only direct map addresses that are marked as E820_RAM

This patch exposes pfn_mapped array, and only sets ident mapping for ranges
in that array.

This patch relies on new kernel_ident_mapping_init that could handle existing
pgd/pud between different calls.

---
>
>> >> That causes same problem that is fixed by
>> >
>> > "Otherwise, it causes the same ..."
>> >
>> >>
>> >>       x86, mm: Only direct map addresses that are marked as E820_RAM
>> >
>> > You could add this patch's commit id since it is in tip:x86/mm2 and it
>> > shouldn't change: 66520ebc2df3.
>>
>> why ? they are not in linus tree yet, so it could change if that tip
>> branch is rebased.
>
> Oh, you didn't know: tip branches don't get rebased. At least almost
> never.

hpa rebased x86/mm2 one time with my patchset according to request from Ingo.
