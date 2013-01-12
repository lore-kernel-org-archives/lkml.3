Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3ALRHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:07:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab3ALRHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:07:19 -0500
Date: Sat, 12 Jan 2013 18:06:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 5/6] uprobes: add bp_vaddr argument to consumer
	handler
Message-ID: <20130112170655.GA20945@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-6-git-send-email-anton@redhat.com> <20121222163545.GE18082@redhat.com> <20121222171329.GA20691@redhat.com> <20121223154910.GA7106@redhat.com> <20130108142715.GA16849@bandura.brq.redhat.com> <50EF43F8.3040403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EF43F8.3040403@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Josh Stone wrote:
>
> For uprobes, systemtap wants regs->ip to be the real breakpoint address,

Just to be sure this didn't escape your attention... Please note that
this becomes true after

	[PATCH 2/2] uprobes: Change handle_swbp() to expose bp_vaddr to handler_chain()
	http://marc.info/?l=linux-kernel&m=135688247630262

so you should no longer use uprobe_get_swbp_addr or inst->vaddr to
change regs->ip.

> and for uretprobes we want the original return address.

Yes, Anton's v2 does this.

But. Don't you also need to know the address of function we are going
to return from?

Probably you do not, uprobe_consumer should know which function (but
not vaddr) it probes, but please confirm.

Oleg.

