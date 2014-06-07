Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaFGVjI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:39:08 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49388 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbaFGVjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:39:06 -0400
Message-ID: <1402177144.2236.26.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] Per-user namespace process accounting
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>
Date: Sat, 07 Jun 2014 14:39:04 -0700
In-Reply-To: <8738flkhf0.fsf@x220.int.ebiederm.org>
References: <5386D58D.2080809@1h.com> <87tx88nbko.fsf@x220.int.ebiederm.org>
	 <53870EAA.4060101@1h.com> <20140529153232.GB9714@ubuntumail>
	 <538DFF72.7000209@parallels.com> <20140603172631.GL9714@ubuntumail>
	 <8738flkhf0.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 10:54 -0700, Eric W. Biederman wrote:
> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> 
> > Quoting Pavel Emelyanov (xemul@parallels.com):
> >> On 05/29/2014 07:32 PM, Serge Hallyn wrote:
> >> > Quoting Marian Marinov (mm@1h.com):
> >> >> We are not using NFS. We are using a shared block storage that offers us snapshots. So provisioning new containers is
> >> >> extremely cheep and fast. Comparing that with untar is comparing a race car with Smart. Yes it can be done and no, I
> >> >> do not believe we should go backwards.
> >> >>
> >> >> We do not share filesystems between containers, we offer them block devices.
> >> > 
> >> > Yes, this is a real nuisance for openstack style deployments.
> >> > 
> >> > One nice solution to this imo would be a very thin stackable filesystem
> >> > which does uid shifting, or, better yet, a non-stackable way of shifting
> >> > uids at mount.
> >> 
> >> I vote for non-stackable way too. Maybe on generic VFS level so that filesystems 
> >> don't bother with it. From what I've seen, even simple stacking is quite a challenge.
> >
> > Do you have any ideas for how to go about it?  It seems like we'd have
> > to have separate inodes per mapping for each file, which is why of
> > course stacking seems "natural" here.
> >
> > Trying to catch the uid/gid at every kernel-userspace crossing seems
> > like a design regression from the current userns approach.  I suppose we
> > could continue in the kuid theme and introduce a iiud/igid for the
> > in-kernel inode uid/gid owners.  Then allow a user privileged in some
> > ns to create a new mount associated with a different mapping for any
> > ids over which he is privileged.
> 
> There is a simple solution.
> 
> We pick the filesystems we choose to support.
> We add privileged mounting in a user namespace.
> We create the user and mount namespace.
> Global root goes into the target mount namespace with setns and performs
> the mounts.
> 
> 90% of that work is already done.
> 
> As long as we don't plan to support XFS (as it XFS likes to expose it's
> implementation details to userspace) it should be quite straight
> forward.

Any implementation which doesn't support XFS is unviable from a distro
point of view.  The whole reason we're fighting to get USER_NS enabled
in distros goes back to lack of XFS support (they basically refused to
turn it on until it wasn't a choice between XFS and USER_NS).  If we put
them in a position where they choose a namespace feature or XFS, they'll
choose XFS.

XFS developers aren't unreasonable ... they'll help if we ask.  I mean
it was them who eventually helped us get USER_NS turned on in the first
place.

James


