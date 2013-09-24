Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740Ab3IXEGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:06:09 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:41179 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab3IXEGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:06:07 -0400
Date: Tue, 24 Sep 2013 00:06:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info' in
 all related extern functions
Message-ID: <20130924040601.GA31575@mtj.dyndns.org>
References: <5212DBFA.8030805@asianux.com>
 <20130923150625.GB14547@htj.dyndns.org>
 <52410A40.1000304@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52410A40.1000304@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 24, 2013 at 11:42:56AM +0800, Chen Gang wrote:
> Hmm... can user be permitted to call other system call (e.g. getgroups)
> before call groups_alloc()? (may the user space already give check, but
> for our kernel, we can not only depend on their checking).

I don't think so.

> According to group_alloc() and setgroups() usage in kernel source code,
> 'group_info' may be not set if kernel/process is running (although user
> space may be sure "if kernel is running, 'group_info' must be set").
> 
> The below is the proof for "kernel itself can not be sure 'group_info'
> must be set during kernel/process is running", please check, thanks.
...
> The related conclusion:
> 
>   during kernel startup or process creation, kernel does not intend to set 'group_info'.

No, this is not a proof or any meaningful conclusion.  This is just
some random suspicions combined with supposedly related grep output.

> In extern function groups_search (which also called by export function
> in_group_p and in_egroup_p), it checks "if 'cred->group_info' is NULL".
> 
> So "kernel/groups.c" have 9 extern/export/system-call functions, and
> 4/9 notice about "if 'cred->group_info' is NULL" (e.g. groups_alloc,
> groups_search, in_group_p, in_egroup_p).
> 
> So for API self-consistency, all of extern/export/system-call functions
> need notice about it.

I'm afraid this isn't useful.  If you want to change the code, you
actually need to understand what's going on.  "this seems weird to me"
is a good starting point but you need to go way beyond that to
actually make changes.

Thanks.

-- 
tejun
