Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3KVVAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:00:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39041 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3KVVA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:00:29 -0500
Message-ID: <528FC5E8.20406@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 16:00:24 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: oleg@redhat.com
CC: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        viro@ZenIV.linux.org.uk, keescook@chromium.org, mhocko@suse.cz,
        snanda@chromium.org, dserrg@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] check_unsafe_exec: kill the dead -EAGAIN and clear_in_exec
 logic
References: <20131122175442.GA31453@redhat.com> <528FBE22.5030208@jp.fujitsu.com> <20131122204917.GA20520@redhat.com>
In-Reply-To: <20131122204917.GA20520@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I have found no problem in this patch. However, I have a very basic question.
>> Why do we need to keep fs->in_exec?
> 
> To ensure that a sub-thread can't create a new process with the same
> ->fs while we are doing exec without LSM_UNSAFE_SHARE, I guess. This
> is only for security/ code.

But in LSM_UNSAFE_SHARE case, we have no check, right? I'm amazing why
we don't need anything.


> 
>> If it is correct,
>> can't we move it it to signal->in_exec?
> 
> Yes, perhaps, I am thinking about more cleanups too. But not that this
> will add the subtle change. CLONE_THREAD doesn't require CLONE_FS, so
> copy_fs() can fail even it the caller doesn't share ->fs with the execing
> thread. And we still need fs->lock to set signal->in_exec, this looks
> a bit strange.

Oops. Yes, this is totally odd. Sorry, we need to stop off topic discussion.
Anyway

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> 
>> I am not expert in this area and I may overlook something.
> 
> Neither me ;) So this patch tries to not change the current logic.
> 
> I feel that perhaps we can do more cleanups, but I am not really sure
> and this needs a separate change.



