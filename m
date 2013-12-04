Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3LDLLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:11:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab3LDLLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:11:18 -0500
Date: Wed, 4 Dec 2013 12:11:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
	page directly
Message-ID: <20131204111125.GA26552@redhat.com>
References: <CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com> <20131203184909.GA17571@redhat.com> <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com> <529E2F0C.8070405@zytor.com> <20131203200147.GB19083@redhat.com> <529E3D4C.9070403@zytor.com> <20131203203826.GA24812@redhat.com> <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com> <20131203205400.GA25735@redhat.com> <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, Linus Torvalds wrote:
>
> On Tue, Dec 3, 2013 at 12:54 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > So do you think the patch I sent is wrong? Why?
>
> I think the TLB shootdown should guarantee that it's ok on other
> CPU's, since that's basically what we do on mmap.

OK, thanks. I'll resend this patch.

It is still not clear to me if we can simply change a single byte on
x86 or not, but at least on powerpc we need to update 4 bytes. Perhaps
we can conditionalize these pte games later.

> But looking closer at this, I think I see why the old code did what it
> did. I think it's breaking shared mmap pages on purpose rather than
> dirtying them. Which is probably the right thing to do.

Ah, no. uprobes never writes to the shared pages. (hmm, it seems that
VM_SHARED check is buggy, but this is offtopic). Otherwise this patch
would be very wrong.

Oleg.

