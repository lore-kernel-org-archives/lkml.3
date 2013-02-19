Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab3BSC1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:27:13 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:9371 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755170Ab3BSC1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:27:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMKAG3iIlF5LHbb/2dsb2JhbABEhWC1PYUSgQQXc4IfAQEEAScTHCMQCAMVAwklDwUlAyETiAwFsUaPfRWNUwdgIj0Hg0ADliuJWYcAgVKBSYFW
Date: Tue, 19 Feb 2013 13:27:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH review 10/16] xfs: Push struct kqid into
 xfs_qm_scall_qmlim and xfs_qm_scall_getquota
Message-ID: <20130219022707.GL26694@dastard>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
 <1361149870-27732-10-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361149870-27732-10-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 05:11:03PM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - In xfs_qm_scall_getquota map the quota id into the callers
>   user namespace in the returned struct fs_disk_quota
> 
> - Add a helper is_superquota and use it in xfs_qm_scall_setqlimi
>   to see if we are setting the superusers quota limit.  Setting
>   the superuses quota limit on xfs sets the default quota limits
>   for all users.

These seem fine.

> - Move xfs_quota_type into xfs_qm_syscalls.c where it is now used.

Now that I've seen the code, I really don't see any advantage to
driving the kqid into XFS quota subsystem. (i.e the rest of this
patch and the subsequent follow up patches that drive it further
inward).

I did say previously:

>> From there, targetted patches can drive the kernel structures
>> inward from the entry points where it makes sense to do so (e.g.
>> common places that the quota entry points call that take a
>> type/id pair).  The last thing that should happen is internal
>> structures be converted from type/id pairs to the kernel types if
>> it makes sense to do so and it makes the code simpler and easier
>> to read....

But seeing the result, IMO, it doesn't actually improve the code
(it's neither simpler nor easier to read), and it doesn't actually
add any functionality. It makes the code strange and different and
somewhat inconsistent and litters id/namespace conversions all over
the place, so i don't think these cahgnes are necessary.

Hence I'd say just do absolute minimum needed for the
is_superquota() checks to work and leave all the kqid ->
xfs_dqid_t+type conversion at the boundary of the quota subsystem
where it already is....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
