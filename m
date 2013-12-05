Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3LEXYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:24:01 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:64045 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3LEXX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:23:59 -0500
Date: Thu, 5 Dec 2013 15:23:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] introduce for_each_thread() to replace the buggy
 while_each_thread()
In-Reply-To: <20131205181620.GB26018@redhat.com>
Message-ID: <alpine.DEB.2.02.1312051521540.7717@chino.kir.corp.google.com>
References: <20131204130409.GA5998@redhat.com> <alpine.DEB.2.02.1312041657210.13608@chino.kir.corp.google.com> <20131205181620.GB26018@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Oleg Nesterov wrote:

> > Minor: should the definitions of thread_{head,node} be annotated with
> > __rcu for users of CONFIG_SPARSE_RCU_POINTER?
> 
> Perhaps. And perhaps task_struct->tasks. And perhaps we should add
> rcu_read_lock_held() || lockdep_is_held(tasklist) || lockdep_is_held(siglock)
> into for_each_process/thead.
> 
> But lets do this later. At least we should avoid the false positives.
> 

Ok, thanks.  I think anything we can do to catch these cases of 
unprotected usage even with some debugging options like 
CONFIG_SPARSE_RCU_POINTER and CONFIG_LOCKDEP will help given the number of 
places you found that were doing it incorrectly already.
