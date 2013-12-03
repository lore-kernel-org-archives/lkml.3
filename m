Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3LCWBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:01:55 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:64184 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3LCWBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:01:49 -0500
MIME-Version: 1.0
In-Reply-To: <20131203205400.GA25735@redhat.com>
References: <20131129200532.GA13561@redhat.com>
	<alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>
	<CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com>
	<20131203184909.GA17571@redhat.com>
	<CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com>
	<529E2F0C.8070405@zytor.com>
	<20131203200147.GB19083@redhat.com>
	<529E3D4C.9070403@zytor.com>
	<20131203203826.GA24812@redhat.com>
	<e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com>
	<20131203205400.GA25735@redhat.com>
Date: Tue, 3 Dec 2013 14:01:47 -0800
X-Google-Sender-Auth: 9vK2T9GwoI1GfwW9fMc9FCXzokA
Message-ID: <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the page directly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
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

On Tue, Dec 3, 2013 at 12:54 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> So do you think the patch I sent is wrong? Why?

I think the TLB shootdown should guarantee that it's ok on other
CPU's, since that's basically what we do on mmap.

But looking closer at this, I think I see why the old code did what it
did. I think it's breaking shared mmap pages on purpose rather than
dirtying them. Which is probably the right thing to do.

              Linus
