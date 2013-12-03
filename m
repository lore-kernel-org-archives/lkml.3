Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3LCUBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:01:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab3LCUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:01:30 -0500
Date: Tue, 3 Dec 2013 21:01:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
	page directly
Message-ID: <20131203200147.GB19083@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz> <CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com> <20131203184909.GA17571@redhat.com> <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com> <529E2F0C.8070405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529E2F0C.8070405@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, H. Peter Anvin wrote:
>
> I guess it would have to be checked, but I would be *highly* surprised
> if UPROBE_SWBP_INSN_SIZE ever[1] could be anything than the fundamental
> instruction quantum, which means it should never be able to wrap a page,

Yes, it can't.

> but *also* should mean it should be able to just be put_user()'d

put_user() obviously can't work, we need access_remote_vm-like code.

> followed by whatever synchronization necessary to make it globally visible.

Could you explain what this synchronization should actually do ?

Oleg.

