Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331Ab3JPMrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:47:41 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42335 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3JPMrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:47:40 -0400
Date: Wed, 16 Oct 2013 18:17:33 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uprobes: Change uprobe_copy_process() to dup
 return_instances
Message-ID: <20131016124733.GG19729@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131013191815.GA32466@redhat.com>
 <20131013191841.GA32499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131013191841.GA32499@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101612-9332-0000-0000-000001CA505C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-10-13 21:18:41]:

> uprobe_copy_process() assumes that the new child doesn't need
> ->utask, it should be allocated by demand.
> 
> But this is not true if the forking task has the pending ret-
> probes, the child should report them as well and thus it needs
> the copy of parent's ->return_instances chain. Otherwise the
> child crashes when it returns from the probed function.
> 
> Note: this change alone doesn't fix the problem, see the next
> change.
> 
> Cc: stable@vger.kernel.org # 3.9+
> Reported-by: Martin Cermak <mcermak@redhat.com>
> Reported-by: David Smith <dsmith@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>


-- 
Thanks and Regards
Srikar Dronamraju

