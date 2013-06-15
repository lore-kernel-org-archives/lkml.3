Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3FOMqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 08:46:46 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:50456 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3FOMqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 08:46:45 -0400
Date: Sat, 15 Jun 2013 14:46:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] hw_breakpoint: Use cpu_possible_mask in
 {reserve,release}_bp_slot()
Message-ID: <20130615124639.GA1965@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601182057.GA4861@redhat.com>
 <20130601182139.GC4861@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601182139.GC4861@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 08:21:39PM +0200, Oleg Nesterov wrote:
> fetch_bp_busy_slots() and toggle_bp_slot() use for_each_online_cpu(),
> this is obviously wrong wrt cpu_up() or cpu_down(), we can over/under
> account the per-cpu numbers.
> 
> For example:
> 
> 	# echo 0 >> /sys/devices/system/cpu/cpu1/online
> 	# perf record -e mem:0x10 -p 1 &
> 	# echo 1 >> /sys/devices/system/cpu/cpu1/online
> 	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10 -C1 -a &
> 	# taskset -p 0x2 1
> 
> triggers the same WARN_ONCE("Can't find any breakpoint slot") in
> arch_install_hw_breakpoint().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
