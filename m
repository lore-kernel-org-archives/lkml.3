Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaKKPhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:37:38 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:53480 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKKPhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:37:36 -0500
Date: Tue, 11 Nov 2014 09:37:32 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, seth.forshee@canonical.com
Subject: Re: [PATCH v5 3/4] fuse: Restrict allow_other to the superblock's
 namespace or a descendant
Message-ID: <20141111153732.GC7906@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Michael j Theall <mtheall@us.ibm.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-4-git-send-email-seth.forshee@canonical.com>
 <20141111152737.GE333@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111152737.GE333@tucsk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 04:27:37PM +0100, Miklos Szeredi wrote:
> On Wed, Oct 22, 2014 at 04:24:19PM -0500, Seth Forshee wrote:
> > Unprivileged users are normally restricted from mounting with the
> > allow_other option by system policy, but this could be bypassed
> > for a mount done with user namespace root permissions. In such
> > cases allow_oth er should not allow users outside the userns
> > to access the mount as doing so would give the unprivileged user
> > the ability to manipulate processes it would otherwise be unable
> > to manipulate. Therefore access with allow_other should be
> > restricted to users in the userns as the superblock or a
> > descendant of that namespace.
> 
> Fine.
> 
> But aren't this kind of thing supposed to be prevented anyway by having private
> mount namespace coupled with the pid-user-whatever namespace?
> 
> It seems like being a bit too careful (not to say that that's a bad thing).

A userns mount should be in a "private" mount namespace; specifically
the user performing the mount must have CAP_SYS_ADMIN in
mnt_ns->user_ns. The mount may still be accessible via /proc/pid/root
though, and doing this ensures that in any case the user can never use
the mount to manipulate processes that it can't already manipulate.

Thanks,
Seth
