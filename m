Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaHTTZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:25:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaHTTZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:25:05 -0400
Date: Wed, 20 Aug 2014 21:22:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mempolicy: get_task_policy() cleanups/preparations
Message-ID: <20140820192207.GA8524@redhat.com>
References: <20140805194627.GA30693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Oleg Nesterov wrote:
>
> With this change the only user of proc_maps_private->task is
> hold_task_mempolicy/release_task_mempolicy. I believe this code is buggy
> and should die, but this needs the changes in mm/mempolicy.c.

I belive that 9e7814404b77c3e8 "hold task->mempolicy while numa_maps scans"
was wrong and it doesn't fix the problem.

I'll try to send the fix tomorrow, could you review the initial preparations?
To me, these changes make sense as cleanups in any case, but I don't really
understand this code and this was only compile tested.

Oleg.

