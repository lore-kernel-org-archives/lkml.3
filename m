Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab3APQVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:21:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab3APQVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:21:14 -0500
Date: Wed, 16 Jan 2013 17:20:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 5/6] uprobes: add bp_vaddr argument to consumer
	handler
Message-ID: <20130116162022.GA2026@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-6-git-send-email-anton@redhat.com> <20121222163545.GE18082@redhat.com> <20121222171329.GA20691@redhat.com> <20121223154910.GA7106@redhat.com> <20130108142715.GA16849@bandura.brq.redhat.com> <50EF43F8.3040403@redhat.com> <20130112170655.GA20945@redhat.com> <50F5AACB.7000303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F5AACB.7000303@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Josh Stone wrote:
>
> On 01/12/2013 09:06 AM, Oleg Nesterov wrote:
> > On 01/10, Josh Stone wrote:
> >> and for uretprobes we want the original return address.
> >
> > Yes, Anton's v2 does this.
> >
> > But. Don't you also need to know the address of function we are going
> > to return from?
> >
> > Probably you do not, uprobe_consumer should know which function (but
> > not vaddr) it probes, but please confirm.
>
> Right, this is fine.

OK, thanks.

> Setting regs->ip to the entry address of the function we just returned
> from would actually be harmful,

Yes, yes, I understand. I meant, ->ret_hander() could have the additional
argument to tell the address of the function.

> Maybe it would be useful if regs->ip reflected the address of the RET
> instruction we just executed, but only if e.g. regs->sp also got rewound
> accordingly.  Since I don't think this is possible, just setting
> regs->ip to the return target is good enough.

Yes, I guess this is not possible.

Oleg.

