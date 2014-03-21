Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbaCUPW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:22:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:23518 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760251AbaCUPW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:22:56 -0400
Date: Fri, 21 Mar 2014 11:22:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>
Subject: Re: [PATCH 1/2] tools lib traceevent: Print event name when show
 warning if possible
Message-ID: <20140321112249.77b5ee70@gandalf.local.home>
In-Reply-To: <1395192174-26273-1-git-send-email-namhyung@kernel.org>
References: <1395192174-26273-1-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 10:22:53 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> It's sometimes useful to know where the parse failure was occurred.
> Add do_warning_event() macro to see the failing event.
> 
> It now shows the messages like below:
> 
>   $ perf test 5
>    5: parse events tests                                     :  Warning: [kvmmmu:kvm_mmu_get_page] bad op token {
>     Warning: [kvmmmu:kvm_mmu_sync_page] bad op token {
>     Warning: [kvmmmu:kvm_mmu_unsync_page] bad op token {
>     Warning: [kvmmmu:kvm_mmu_prepare_zap_page] bad op token {
>     Warning: [kvmmmu:fast_page_fault] function is_writable_pte not defined
>     Warning: [xen:xen_mmu_ptep_modify_prot_commit] function sizeof not defined
>     Warning: [xen:xen_mmu_ptep_modify_prot_start] function sizeof not defined
>     Warning: [xen:xen_mmu_set_pgd] function sizeof not defined
>     Warning: [xen:xen_mmu_set_pud] function sizeof not defined
>     Warning: [xen:xen_mmu_set_pmd] function sizeof not defined

Nice feature.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>     ...
> 
