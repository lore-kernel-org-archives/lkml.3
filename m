Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3FOM7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 08:59:33 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:51772 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3FOM7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 08:59:31 -0400
Date: Sat, 15 Jun 2013 14:59:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/3] hw_breakpoint: Simplify list/idx mess in
 toggle_bp_slot() paths
Message-ID: <20130615125926.GB1965@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601194526.GA27149@redhat.com>
 <20130601194548.GB27149@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601194548.GB27149@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 09:45:48PM +0200, Oleg Nesterov wrote:
> The enable/disable logic in toggle_bp_slot() is not symmetrical
> and imho very confusing. "old_count" in toggle_bp_task_slot() is
> actually new_count because this bp was already removed from the
> list.
> 
> Change toggle_bp_slot() to always call list_add/list_del after
> toggle_bp_task_slot(). This way old_idx is task_bp_pinned() and
> this entry should be decremented, new_idx is +/-weight and we
> need to increment this element. The code/logic looks obvious.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice :-)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
