Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaIDTPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:15:17 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:56102 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaIDTPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:15:15 -0400
MIME-Version: 1.0
In-Reply-To: <1409857025.28990.125.camel@misato.fc.hp.com>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
 <1409855739-8985-5-git-send-email-toshi.kani@hp.com> <CALCETrXjpoVmCi07zo0dKH9LrF+nz9F3GshNiQvmiueFFH=TUQ@mail.gmail.com>
 <1409857025.28990.125.camel@misato.fc.hp.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 4 Sep 2014 12:14:54 -0700
Message-ID: <CALCETrUrbQm72_U4uGCCdNr1uww0+avmwu2N_tHRcdevRJCyvQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86, mm: Add set_memory_wt() for WT
To: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, akpm@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 11:57 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Thu, 2014-09-04 at 11:57 -0700, Andy Lutomirski wrote:
>> On Thu, Sep 4, 2014 at 11:35 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>> > This patch adds set_memory_wt(), set_memory_array_wt(), and
>> > set_pages_array_wt() for setting range(s) of memory to WT.
>> >
>>
>> Possibly dumb question: I thought that set_memory_xyz was only for
>> RAM.  Is that incorrect?
>
> It works for non-RAM ranges as well.  For instance, you can use
> set_memory_xyz() to change cache attribute for a non-RAM range mapped by
> ioremap_cache().

OK -- I didn't realize that was legal.

Do you, by any chance, have a test driver for this?  For example,
something that lets your reserve some WT memory at boot and mmap it?
I wouldn't mind getting some benchmarks, and I can even throw it at
the NV-DIMM box that's sitting under my desk :)

--Andy
