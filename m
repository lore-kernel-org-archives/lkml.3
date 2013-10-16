Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298Ab3JPMhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:37:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41128 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934095Ab3JPMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:37:13 -0400
Date: Wed, 16 Oct 2013 18:07:04 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] uprobes: Change the callsite of uprobe_copy_process()
Message-ID: <20131016123704.GD19729@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131013191815.GA32466@redhat.com>
 <20131013191831.GA32480@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131013191831.GA32480@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101612-0928-0000-0000-000002996A33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-10-13 21:18:31]:

> Preparation for the next patches.
> 
> Move the callsite of uprobe_copy_process() in copy_process() down
> to the succesfull return. We do not care if copy_process() fails,
> uprobe_free_utask() won't be called in this case so the wrong
> ->utask != NULL doesn't matter.
> 
> OTOH, with this change we know that copy_process() can't fail when
> uprobe_copy_process() is called, the new task should either return
> to user-mode or call do_exit(). This way uprobe_copy_process() can:
> 
> 	1. setup p->utask != NULL if necessary
> 
> 	2. setup uprobes_state.xol_area
> 
> 	3. use task_work_add(p)
> 
> Also, move the definition of uprobe_copy_process() down so that it
> can see get_utask().
> 
> Cc: stable@vger.kernel.org # 3.9+
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>


-- 
Thanks and Regards
Srikar Dronamraju

