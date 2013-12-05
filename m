Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3LEAjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:39:13 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:49773 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3LEAjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:39:09 -0500
Date: Wed, 4 Dec 2013 16:39:06 -0800 (PST)
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
Subject: Re: [PATCH v2 2/4] oom_kill: change oom_kill.c to use
 for_each_thread()
In-Reply-To: <20131204130412.GA6005@redhat.com>
Message-ID: <alpine.DEB.2.02.1312041638520.31158@chino.kir.corp.google.com>
References: <20131204130412.GA6005@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Oleg Nesterov wrote:

> Change oom_kill.c to use for_each_thread() rather than the racy
> while_each_thread() which can loop forever if we race with exit.
> 
> Note also that most users were buggy even if while_each_thread()
> was fine, the task can exit even _before_ rcu_read_lock().
> 
> Fortunately the new for_each_thread() only requires the stable
> task_struct, so this change fixes both problems.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-and-Tested-by: Sergey Dyasly <dserrg@gmail.com>
> Reviewed-by: Sameer Nanda <snanda@chromium.org>

Acked-by: David Rientjes <rientjes@google.com>
