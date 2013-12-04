Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab3LDRPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:15:10 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:50734 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556Ab3LDRPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:15:06 -0500
MIME-Version: 1.0
In-Reply-To: <529F5E47.3040108@zytor.com>
References: <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com>
	<529E2F0C.8070405@zytor.com>
	<20131203200147.GB19083@redhat.com>
	<529E3D4C.9070403@zytor.com>
	<20131203203826.GA24812@redhat.com>
	<e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com>
	<20131203205400.GA25735@redhat.com>
	<CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com>
	<20131204111125.GA26552@redhat.com>
	<529F51D9.7010001@zytor.com>
	<20131204164817.GA5271@redhat.com>
	<529F5E47.3040108@zytor.com>
Date: Wed, 4 Dec 2013 09:15:04 -0800
X-Google-Sender-Auth: TDn6Jmbsis8PBnVqt4VnHuJKzpY
Message-ID: <CA+55aFyMx74jiKgS-o0axuuTBw7295UEMSf_vYDQCAghk3Vr=w@mail.gmail.com>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the page directly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 8:54 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> That is why I talk about the atomic instruction word... most (but not
> *all*) architectures have a fundamental minimum unit of instructions
> which is aligned and can be atomically written.  Typically this is 1, 2,
> or 4 bytes.

Note that it's not just about the "atomically written", it's also
about the guarantee that it's atomically *read*.

x86 can certainly atomically write a 4-byte instruction too, it's just
that there's no guarantee - even if the instruction is aligned etc -
that the actual instruction decoding always ends up reading it that
way. It might re-read an instruction after encountering a prefix byte
etc etc. So even if it's all properly aligned, the reading side might
do something odd.

            Linus
