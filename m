Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3AUS2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:28:20 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:61706 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab3AUS2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:28:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130121172151.GA4691@redhat.com>
References: <20130118153700.GA27915@redhat.com> <CA+55aFxEow_-PoX0xFa07yOi6az=6uVx8zeOsfToErmzh7dB8A@mail.gmail.com>
 <20130118172854.GA29753@redhat.com> <20130118175224.GA520@redhat.com>
 <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com>
 <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com>
 <20130120192448.GA6771@redhat.com> <20130120192527.GC6771@redhat.com>
 <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com> <20130121172151.GA4691@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Jan 2013 10:27:58 -0800
X-Google-Sender-Auth: zEPCxe3SBC_adUdy9zQzz2kLcqA
Message-ID: <CA+55aFwRkvEP5YJy+a=TFgDX==YuU7CJ+D_U+B2s4e1LX-nz3g@mail.gmail.com>
Subject: Re: [PATCH 2/4] ptrace: ensure arch_ptrace/ptrace_request can never
 race with SIGKILL
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Kernel Security <security@kernel.org>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 9:21 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> This is what initial patch did. But, assuming that ptrace_unfreeze_traced()
> is called unconditionally, we need a locking or barriers, otherwise

Ahh. Fair enough.

I guess that works then. It's a bit sad, but at least I see why you did it.

                  Linus
