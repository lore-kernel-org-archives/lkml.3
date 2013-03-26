Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab3CZOiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:38:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933438Ab3CZOiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:38:00 -0400
Date: Tue, 26 Mar 2013 15:34:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 4/7] uretprobes: return probe entry, prepare_uretprobe()
Message-ID: <20130326143438.GA1065@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-5-git-send-email-anton@redhat.com> <20130322150252.GA17934@redhat.com> <20130326122601.GA1935@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326122601.GA1935@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Anton Arapov wrote:
>
> On Fri, Mar 22, 2013 at 04:02:52PM +0100, Oleg Nesterov wrote:
> > > +	ri->dirty = false;
> > > +	trampoline_vaddr = get_trampoline_vaddr(area);
> > > +	ret_vaddr = arch_uretprobe_hijack_return_addr(trampoline_vaddr, regs);
> >
> > OK, but you need to ensure that this code can be compiled on poweprc.
>
> It does compile, unlike the obvious arch_uretprobe_hijack_return_addr() where
> I'll look for the Ananth's help, perhaps.

Just make the default weak function which returns -1.

After that Ananth can send the (hopefully simple) patch with the
powerpc implementation.

Oleg.

