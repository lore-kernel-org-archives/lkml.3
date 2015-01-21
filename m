Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbbAUNoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:44:38 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:62945 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbbAUNob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:44:31 -0500
MIME-Version: 1.0
In-Reply-To: <1421581520-2816-3-git-send-email-heukelum@fastmail.fm>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm> <1421581520-2816-3-git-send-email-heukelum@fastmail.fm>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 21 Jan 2015 14:44:10 +0100
Message-ID: <CAK1hOcMgrpw5+Uz+5U25Xq_1fJNTGc4PUtw+YzGGYBZ-YKaJew@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] x86_64: embrace KERNEL_STACK_OFFSET
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@suse.de>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 12:45 PM, Alexander van Heukelum
<heukelum@fastmail.fm> wrote:
> KERNEL_STACK_OFFSET is the offset from the top of the kernel stack
> page to the value of the kernel_stack percpu variable. This patch
> changes KERNEL_STACK_OFFSET to configure a reserved space of 16
> bytes above the user ptregs frame. KERNEL_STACK_OFFSET must be
> set to a multiple of 16 bytes due to the automatic stack alignment
> of interrupts, traps, and exceptions on x86_64.

I propose to set kernel_stack percpu variable to point
to the top of kernel stack (obvious, isn't it?)
and eliminate KERNEL_STACK_OFFSET altogether.
