Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3CWSHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 14:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3CWSHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 14:07:07 -0400
Date: Sat, 23 Mar 2013 19:04:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Josh Stone <jistone@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 0/7] uretprobes: return probes implementation
Message-ID: <20130323180443.GB4076@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <20130322151034.GC17286@redhat.com> <514CCFDA.2080305@redhat.com> <20130323064324.GA1960@bandura.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323064324.GA1960@bandura.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Anton Arapov wrote:
>
>   IIUC, Oleg have stressed that perf and trace events requires
> additional code to leverage the return probes. IOW this patchset
> implements core only and to use it we need to teach the perf about
> rp_handler().

Yes,

>   And I don't see why we would need additional parameter for
> rp_handler() as well.

trace_uprobe should use the same fmt = "(%lx <- %lx)" to teport
"entry <- exit" info, like trace_kprobe does.

And note that, unlike kprobe, the same function can be mmapped at
different address by different (or even the same) tasks.



But mostly I just wanted to say that yes, we will also teach
trace_uprobe to use the new feature before we ask to merge this
code.

Oleg.

