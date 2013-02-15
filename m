Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935725Ab3BOPLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:11:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab3BOPLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:11:01 -0500
Date: Fri, 15 Feb 2013 16:09:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] x86: make PTRACE_GETREGSET return 32-bit regs if
	64-bit process entered kernel with int 80
Message-ID: <20130215150940.GA31861@redhat.com>
References: <511CE3D0.8000308@redhat.com> <20130214150046.GA30543@redhat.com> <511D2779.7040504@zytor.com> <20130214191842.GA11620@redhat.com> <511D3928.80402@zytor.com> <20130214205521.GA20085@moon> <511E4B43.7040202@redhat.com> <20130215145648.GE8193@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215145648.GE8193@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Cyrill Gorcunov wrote:
>
> > strace needs to get that data on every syscall entry in the traced process.
> > Doing open/read/close on every syscall entry is going to slow it down a lot.
>
> Don't you need to read it only once when strace is attached? Compat flag can't
> be arbitrary dropped when program executes, no?

TS_COMPAT is set/cleared every time a 64bit task does int80.

I guess you need TIF_IA32, not TS_COMPAT, for c/r.

Oleg.

