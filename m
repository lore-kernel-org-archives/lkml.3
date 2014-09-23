Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaIWQ0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:26:30 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:53057 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaIWQ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:26:28 -0400
Date: Tue, 23 Sep 2014 11:26:22 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140923162622.GA28059@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
 <CAJfpegv4RJzWV7=oHvyUWqUnJYk8JHrQsiKfJ5AMRFRaN3frxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv4RJzWV7=oHvyUWqUnJYk8JHrQsiKfJ5AMRFRaN3frxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:07:35PM +0200, Miklos Szeredi wrote:
> On Tue, Sep 2, 2014 at 5:44 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> > Here's an updated set of patches for allowing fuse mounts from pid and
> > user namespaces. I discussed some of the issues we debated with the last
> > patch set (and a few others) with Eric at LinuxCon, and the updates here
> > mainly reflect the outcome of those discussions.
> >
> > The stickiest issue in the v1 patches was the question of where to get
> > the user and pid namespaces from that are used for translating ids for
> > communication with userspace. Eric told me that for user namespaces at
> > least we need to grab a namespace at open or mount time and use only
> > that namespace to prevent certain types of attacks.
> 
> I'm not convinced.  Let us have the gory details, please.

I'll do my best, and hopefully Eric will fill in any details I miss.

I think there may have been more than one possible scenario that Eric
was describing to me, but this is the one I remember. A user could
create a namespace and mount a fuse filesystem without nosuid. It could
then pass the /dev/fuse fd to a process in init_user_ns, which could
expose a suid file owned by root (or any other user) and use it to gain
elevated privileges.

On the other hand, if file ownership is always interpreted in the
context of the namespace from which the filesystem is mounted then suid
can only be used to become another uid already under that user's
control.

Eric, does that sound right? Did I miss anything?

Seth

