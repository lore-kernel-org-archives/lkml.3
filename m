Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbbAUQ3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:29:23 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59356 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbbAUQ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:29:15 -0500
Message-Id: <1421857754.173957.216801721.380D3A16@webmail.messagingengine.com>
X-Sasl-Enc: KlJGs2fSZueDgrbcUDY4s48iE81a1ACFyEFr43PB+pIX 1421857754
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@suse.de>,
        Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-46f3f2c7
In-Reply-To: <CAK1hOcMgrpw5+Uz+5U25Xq_1fJNTGc4PUtw+YzGGYBZ-YKaJew@mail.gmail.com>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
 <1421581520-2816-3-git-send-email-heukelum@fastmail.fm>
 <CAK1hOcMgrpw5+Uz+5U25Xq_1fJNTGc4PUtw+YzGGYBZ-YKaJew@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] x86_64: embrace KERNEL_STACK_OFFSET
Date: Wed, 21 Jan 2015 17:29:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015, at 14:44, Denys Vlasenko wrote:
> On Sun, Jan 18, 2015 at 12:45 PM, Alexander van Heukelum
> <heukelum@fastmail.fm> wrote:
> > KERNEL_STACK_OFFSET is the offset from the top of the kernel stack
> > page to the value of the kernel_stack percpu variable. This patch
> > changes KERNEL_STACK_OFFSET to configure a reserved space of 16
> > bytes above the user ptregs frame. KERNEL_STACK_OFFSET must be
> > set to a multiple of 16 bytes due to the automatic stack alignment
> > of interrupts, traps, and exceptions on x86_64.
> 
> I propose to set kernel_stack percpu variable to point
> to the top of kernel stack (obvious, isn't it?)
> and eliminate KERNEL_STACK_OFFSET altogether.

By "top of kernel stack", do you mean the page boundary or the
top of struct pt_regs on the kernel stack? (is it really that obvious?)
I think Borislav did the latter for x86_64 in his patchset.

Eliminating KERNEL_STACK_OFFSET was what I did in my first
attempt, and I broke i386 by not thinking through what x86 common
code was really doing :).
