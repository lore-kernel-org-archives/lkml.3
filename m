Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3LEI3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:29:08 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:58556 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053Ab3LEI3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:29:04 -0500
Message-ID: <1386232100.16677.7.camel@linaro1.home>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
 page directly
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Date: Thu, 05 Dec 2013 08:28:20 +0000
In-Reply-To: <CA+55aFyMx74jiKgS-o0axuuTBw7295UEMSf_vYDQCAghk3Vr=w@mail.gmail.com>
References: <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com>
	 <529E2F0C.8070405@zytor.com> <20131203200147.GB19083@redhat.com>
	 <529E3D4C.9070403@zytor.com> <20131203203826.GA24812@redhat.com>
	 <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com>
	 <20131203205400.GA25735@redhat.com>
	 <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com>
	 <20131204111125.GA26552@redhat.com> <529F51D9.7010001@zytor.com>
	 <20131204164817.GA5271@redhat.com> <529F5E47.3040108@zytor.com>
	 <CA+55aFyMx74jiKgS-o0axuuTBw7295UEMSf_vYDQCAghk3Vr=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 09:15 -0800, Linus Torvalds wrote:
> On Wed, Dec 4, 2013 at 8:54 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > That is why I talk about the atomic instruction word... most (but not
> > *all*) architectures have a fundamental minimum unit of instructions
> > which is aligned and can be atomically written.  Typically this is 1, 2,
> > or 4 bytes.
> 
> Note that it's not just about the "atomically written", it's also
> about the guarantee that it's atomically *read*.
> 
> x86 can certainly atomically write a 4-byte instruction too, it's just
> that there's no guarantee - even if the instruction is aligned etc -
> that the actual instruction decoding always ends up reading it that
> way. It might re-read an instruction after encountering a prefix byte
> etc etc. So even if it's all properly aligned, the reading side might
> do something odd.

The ARM architecture has similar issues. Even though the instruction
size is mostly fixed, the architecture specification itself only
guarantees a very tiny subset of instructions are safe to modify whilst
there may be concurrent execution of that instruction. I'm quoting a
discussion from a while ago: http://lkml.org/lkml/2012/12/10/346

-- 
Tixy



