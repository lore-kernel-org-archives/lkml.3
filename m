Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaJQPfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:35:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaJQPfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:35:11 -0400
Date: Fri, 17 Oct 2014 17:31:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm
	tree
Message-ID: <20141017153155.GB7227@redhat.com>
References: <20141016203954.GA26336@redhat.com> <20141017065947.GA8076@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017065947.GA8076@dhcp22.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Michal Hocko wrote:
>
> Can we simply make the task sleep interruptible?

No, this will turn __refrigerator() into the busy-wait loop if
signal_pending() == T.


(but I still think it makes sense to kill PF_FROZEN and introduce
 TASK_FROZEN state, however this is offtopic).

Oleg.

