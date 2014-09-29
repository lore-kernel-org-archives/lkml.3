Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaI2TRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:17:50 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:64488 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaI2TRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:17:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com>
 <54299979.6080705@amacapital.net> <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 12:17:27 -0700
Message-ID: <CALCETrX7yce2PfYi-Gqkf116a1rXUzjKkO3JAf==zd3WuZuDsQ@mail.gmail.com>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:59 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 29 Sep 2014, Andy Lutomirski wrote:
>> Presumably interrupt delivery clears NT.  I haven't spotted where that's
>> documented yet.
>
> Nope, that's unrelated.

If it weren't the case, then we'd be totally screwed.  Fortunately, it
is.  I found it: SDM Volume 3 6.12.1.2 says:

(On calls to exception and interrupt
handlers, the processor also clears the VM, RF, and NT flags in the
EFLAGS register,
after they are saved on the stack.)

--Andy
