Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3B1UDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:03:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab3B1UDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:03:03 -0500
Date: Thu, 28 Feb 2013 21:01:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v3 3/6] uretprobes: generalize xol_get_insn_slot()
Message-ID: <20130228200117.GA9074@redhat.com>
References: <1362049215-5780-1-git-send-email-anton@redhat.com> <1362049215-5780-4-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362049215-5780-4-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton, I'll try to read this series asap. Just one note,

On 02/28, Anton Arapov wrote:
>
>   Generalize xol_take_insn_slot() to enable more consumers of the
> function, e.g. trampoline implementation for return probes.

Yes, this is can work too.

But I guess you misunderstood me, or I missed something...

Why do you need xol_area->rp_trampoline_vaddr at all? From the very
beginning I am trying to suggest to use the first slot for trampoline:

	Or. Perhaps even better, do not add this helper at all. xol_alloc_area()
	could reserve the first slot/bit for trampoline. And note that in this
	case we do not need xol_area->rp_trampoline_vaddr, it is always equal
	to xol_area->vaddr.

Doesn't this look simpler?

Oleg.

