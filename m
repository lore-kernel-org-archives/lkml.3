Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3CWGpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 02:45:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab3CWGpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 02:45:08 -0400
Date: Sat, 23 Mar 2013 07:43:24 +0100
From: Anton Arapov <anton@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 0/7] uretprobes: return probes implementation
Message-ID: <20130323064324.GA1960@bandura.redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
 <20130322151034.GC17286@redhat.com>
 <514CCFDA.2080305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514CCFDA.2080305@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 02:40:42PM -0700, Josh Stone wrote:
> On 03/22/2013 08:10 AM, Oleg Nesterov wrote:
> > This looks simple, but probably we need to add the additional "ulong bp_vaddr"
> > argument for rp_handler().
> 
> FWIW, in SystemTap we don't currently do anything that would need
> bp_vaddr.  The uprobe_consumer already gives the context, so I'm not
> sure what else you would do with the *entry* address of the function
> that just returned.  Perhaps you could emulate an additional top line on
> a stacktrace, but it doesn't tell you where in the function you were.

  IIUC, Oleg have stressed that perf and trace events requires
additional code to leverage the return probes. IOW this patchset
implements core only and to use it we need to teach the perf about
rp_handler().
  And I don't see why we would need additional parameter for 
rp_handler() as well.

Anton
