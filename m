Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaCCKkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:40:07 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35976 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752263AbaCCKkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:40:05 -0500
Date: Mon, 3 Mar 2014 10:39:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: David Long <dave.long@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/14] uprobes: Add uprobes support for ARM
Message-ID: <20140303103902.GG21483@n2100.arm.linux.org.uk>
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org> <20140301123026.GD21483@n2100.arm.linux.org.uk> <53131DBE.7020500@linaro.org> <20140303062324.GB20583@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303062324.GB20583@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 11:53:24AM +0530, Srikar Dronamraju wrote:
> I know there were more discussions on this, but I cant dig them out at
> this time.  Finally it was decided that
> 1. Users shouldnt have to select more than one config to select Uprobes.
> 2. There was no point in selecting Uprobes and not having Uprobe_event
> and vice versa.
> 
> >From the above, If a user chose UPROBE_EVENT, (which is the interface
> for uprobes), we would automatically assume that he wants to use Uprobes
> framework.

That much is fine - however, UPROBES itself is effectively not a user
selectable symbol, even today.  As I've already pointed it, it's
impossible for the user to select because it depends on UPROBE_EVENT,
but when UPROBE_EVENT is enabled, it's forced to be set to "y" meaning
that the user can't turn UPROBES off.

So, the UPROBES symbol has two states:
1. hidden, because its dependencies aren't satisfied.
2. force-y, because UPROBE_EVENT is enabled.

Hence, UPROBES itself serves no purpose.

Now, the solution you mentioned in:

	http://article.gmane.org/gmane.linux.kernel/1017186

looks entirely reasonable to me if there is the desire to keep the two
separate - but from what Frederic said in that post, it seems that there
isn't.

So I'd suggest just getting rid of this UPROBES symbol, moving the
dependency of PERF_EVENTS to UPROBE_EVENTS.  If another interface to
uprobes comes along, it can always be reintroduced in the manner you
suggested in the above.

Either solution should resolve the issue we're seeing on ARM with
David's patches.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
