Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3BORA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:00:57 -0500
Received: from fieldses.org ([174.143.236.118]:53700 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab3BORA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:00:56 -0500
Date: Fri, 15 Feb 2013 12:00:52 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: [PATCH review 52/85] sunrpc: Properly encode kuids and kgids in
 auth.unix.gid rpc pipe upcalls.
Message-ID: <20130215170052.GN8343@fieldses.org>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
 <1360777934-5663-52-git-send-email-ebiederm@xmission.com>
 <20130213210545.GO14195@fieldses.org>
 <874nhfrjgg.fsf@xmission.com>
 <20130213215047.GR14195@fieldses.org>
 <8738wzq1z6.fsf@xmission.com>
 <20130213225840.GV14195@fieldses.org>
 <87ip5vn6iv.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip5vn6iv.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 03:22:32PM -0800, Eric W. Biederman wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> > On Wed, Feb 13, 2013 at 02:32:29PM -0800, Eric W. Biederman wrote:
> >> Now looking at the nfs server, seems to be hard coded to only start
> >> in the initial network namespace despite almost having support for
> >> starting in more.
> >
> > Right, Stanislav's got 4 more patches that should finish the job; see
> > http://mid.gmane.org/<20130201125210.3257.46454.stgit@localhost.localdomain>
> > and followups.  That should make it for 3.9, I just need to review
> > them....
> 
> Ok that is interesting.
> 
> There is an interesting corner case here where an unprivileged user
> can create a user namespace and then can create a network namespace.
> Depending on how we interpret things when Stanislaves patches reach
> there we might have to add:
> 
> if (net->user_ns != &init_user_ns)
> 	-EINVAL
> 
> Somewhere appropriate.

I'm assuming that's something that's needed only in kernels that have
*both* Stanislav's patches and yours.

I've committed his patches to

	git://linux-nfs.org/~bfields/linux.git for-3.9

which should also get pulled into next.  Let me know if there's another
patch I should take.

> I am a touch concerned about /proc/fs/nfsd/exports after my patches
> and Stanislavs patches both come in.  As I think that will allow for
> cases where net->user_ns != &init_userns.  But we can cross that bridge
> when we come to it.

OK, let me know of anything I can do to make your life easier....

--b.
