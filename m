Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaHDPhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:37:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaHDPhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:37:06 -0400
Date: Mon, 4 Aug 2014 17:34:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
	pt_regs"
Message-ID: <20140804153459.GA5236@redhat.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com> <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <CALCETrWA6SL52SOM3yifvc0Pjz-HTOvs8G8fXo9TqF5v=0eTzw@mail.gmail.com> <CAK1hOcOwD0cpVWZEV8FP40y9149feUdaxoszQC+wWQfAwU4MNQ@mail.gmail.com> <20140804144735.GA22438@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804144735.GA22438@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Oleg Nesterov wrote:
>
> On 08/04, Denys Vlasenko wrote:
> >
> > "why do we need percpu old_rsp thingy?" in particular.
>
> See thread_struct->usersp, current_user_stack_pointer().

Btw, perhaps it makes sense to document that task_pt_regs(current)->sp
is not current_user_stack_pointer() inside system_call_fastpath.

Oleg.

