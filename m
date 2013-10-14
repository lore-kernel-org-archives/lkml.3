Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3JNOUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:20:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53617 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab3JNOT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:19:59 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20131014083035.GA20976@gmail.com>
References: <20131011013954.GA28902@www.outflux.net> <tip-d751c169e9a6f0f853346f1184881422bd10b3c2@git.kernel.org> <20131014083035.GA20976@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/kaslr] x86, relocs: Add more per-cpu gold special cases
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 14 Oct 2013 07:19:22 -0700
To: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, md@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Message-ID: <007cdb12-9fc7-4744-8686-695891b926a3@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My guess is that the 95 addresses are randomized and the 82 address is an address which failed to relocate.

Ingo Molnar <mingo@kernel.org> wrote:
>
>* tip-bot for Michael Davidson <tipbot@zytor.com> wrote:
>
>> Commit-ID:  d751c169e9a6f0f853346f1184881422bd10b3c2
>> Gitweb:    
>http://git.kernel.org/tip/d751c169e9a6f0f853346f1184881422bd10b3c2
>> Author:     Michael Davidson <md@google.com>
>> AuthorDate: Thu, 10 Oct 2013 18:39:54 -0700
>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Sun, 13 Oct 2013 03:11:57 -0700
>> 
>> x86, relocs: Add more per-cpu gold special cases
>
>I'm quite sure that one of the recent x86/kaslr changes causes this
>early 
>x86-64 crash:
>
> BRK [0x179fb000, 0x179fbfff] PGTABLE
> BRK [0x179fc000, 0x179fcfff] PGTABLE
> BRK [0x179fd000, 0x179fdfff] PGTABLE
>PANIC: early exception 0e rip 10:ffffffff95203b9c error 0 cr2
>ffffffff82a04a58
> CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc5+ #229838
>Hardware name: System manufacturer System Product Name/A8N-E, BIOS ASUS
>
> A8N-E ACPI BIOS Revision 1008 08/22/2005
>PANIC: early exception 0e rip 10:ffffffff95203e01 error 0 cr2
>ffffffff82a04a58
>
>Config and crashlog attached.
>
>ffffffff95203b9c and ffffffff95203e01 is well outside the executable
>range 
>is thus not in the vmlinux.
>
>ffffffff82a04a58 is:
>
>ffffffff82a03000 t init_per_cpu__gdt_page
>ffffffff82bcd000 t _sinittext
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
