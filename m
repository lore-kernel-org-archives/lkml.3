Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3LESPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:15:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3LESPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:15:24 -0500
Date: Thu, 5 Dec 2013 19:16:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] introduce for_each_thread() to replace the
	buggy while_each_thread()
Message-ID: <20131205181620.GB26018@redhat.com>
References: <20131204130409.GA5998@redhat.com> <alpine.DEB.2.02.1312041657210.13608@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312041657210.13608@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04, David Rientjes wrote:
>
> Acked-by: David Rientjes <rientjes@google.com>

Thanks!

> Minor: should the definitions of thread_{head,node} be annotated with
> __rcu for users of CONFIG_SPARSE_RCU_POINTER?

Perhaps. And perhaps task_struct->tasks. And perhaps we should add
rcu_read_lock_held() || lockdep_is_held(tasklist) || lockdep_is_held(siglock)
into for_each_process/thead.

But lets do this later. At least we should avoid the false positives.

Oleg.

