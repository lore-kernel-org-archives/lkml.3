Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3E0JDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:03:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37993 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3E0JDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:03:52 -0400
Date: Mon, 27 May 2013 11:03:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Li Zefan <lizefan@huawei.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 1/1] sched/autogroup: Fix race with task_groups list
Message-ID: <20130527090338.GG2781@laptop>
References: <1369411669-46971-1-git-send-email-gerald.schaefer@de.ibm.com>
 <1369411669-46971-2-git-send-email-gerald.schaefer@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369411669-46971-2-git-send-email-gerald.schaefer@de.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 06:07:49PM +0200, Gerald Schaefer wrote:
> In autogroup_create(), a tg is allocated and added to the task_groups
> list. If CONFIG_RT_GROUP_SCHED is set, this tg is then modified while on
> the list, without locking. This can race with someone walking the list,
> like __enable_runtime() during CPU unplug, and result in a use-after-free
> bug.
> 
> To fix this, move sched_online_group(), which adds the tg to the list,
> to the end of the autogroup_create() function after the modification.
> 
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

Ah indeed, nice catch. Thanks!
