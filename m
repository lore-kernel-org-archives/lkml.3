Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3DLMYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:24:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3DLMYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:24:46 -0400
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Cliff Wickman <cpw@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead of memmap= boot parameter
Date: Fri, 12 Apr 2013 14:24:43 +0200
Message-ID: <1461590.iEg3524C4m@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com>
References: <1365683207-42425-1-git-send-email-trenn@suse.de> <1365683207-42425-6-git-send-email-trenn@suse.de> <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 11, 2013 07:55:57 AM Yinghai Lu wrote:
> On Thu, Apr 11, 2013 at 5:26 AM, Thomas Renninger <trenn@suse.de> wrote:
> > Currently ranges are passed via kernel boot parameters:
> > memmap=exactmap memmap=X#Y memmap=
> > 
> > Pass them via e820 table directly instead.
> 
> how to address "saved_max_pfn" referring in kernel?
Yes, this patch won't work as I miss out the previously usable memory
totally.
I have to re-work this one and also pass these ranges as discussed
via a KDUMP_RESERVED or even better a KDUMP_MEMORY e820 type.
KDUMP_RESERVED could get used for reserved memory inside the crash
kernel range at some point of time if it is useful.

Can the other patches get applied already if they are fine?
 
> kernel need to use saved_max_pfn from old e820 in
> drivers/char/mem.c::read_oldmem()
> 
> mips and powerpc they are passing that from command line "savemaxmem="
> 
> x86 should use that too?
I could add that.
But things cannot get cleaned up because things have to be
compatible to old kexec tools not passing this param at least for
quite some time.

      Thomas
