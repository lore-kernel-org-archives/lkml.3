Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbbAUSEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:04:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbbAUSEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:04:33 -0500
Date: Wed, 21 Jan 2015 19:04:30 +0100
From: Borislav Petkov <bp@suse.de>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCHv2 1/4] x86_64: cleanup THREAD_INFO(reg,offset) macro
Message-ID: <20150121180429.GB31527@pd.tnic>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
 <1421581520-2816-2-git-send-email-heukelum@fastmail.fm>
 <CAK1hOcMqp8pHVLRPfH9ui1UFvnU1M2bUpdkecdGW-cmSHth9_Q@mail.gmail.com>
 <1421857209.171127.216796445.0DC88E13@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421857209.171127.216796445.0DC88E13@webmail.messagingengine.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 05:20:09PM +0100, Alexander van Heukelum wrote:
> On Wed, Jan 21, 2015, at 14:40, Denys Vlasenko wrote:
> > On Sun, Jan 18, 2015 at 12:45 PM, Alexander van Heukelum
> > <heukelum@fastmail.fm> wrote:
> > > The macro THREAD_INFO(reg,offset) is used in assembly to compute the
> > > offset between the user ptregs and the thread_info struct. Change
> > > the macro and all its uses so that offset is given as the current
> > > top of stack in the pt_regs frame. The generated code is identical.
> > 
> > What is the purpose of doing this?
> > 
> > I don't mean to say that it's pointless, but it is also not obvious
> > why it's better than the code before patch.
> 
> Just because I had a hard time understanding what the offset
> parameter means. Turns out Borislav did another variant in his
> patchset. Quoting him from the commit message which made
> that the change:
> > Semi-mysterious expressions THREAD_INFO(%rsp,RIP) - "why RIP??"
> > are now replaced by more logical THREAD_INFO(%rsp,SIZEOF_PTREGS) -
> > "rsp is SIZEOF_PTREGS bytes below the top, calculate
> > thread_info's address using that information"
> 
> Borislav expresses "offset" as an offset from the stack's page
> boundary,while I chose the offset from the start of struct
> pt_regs on the stack.

I've never done any such thing :-)

s/Borislav/Denys/g.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
