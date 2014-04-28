Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaD1NjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:39:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44103 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609AbaD1NjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:39:13 -0400
Date: Mon, 28 Apr 2014 13:39:08 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: pid ns feature request
Message-ID: <20140428133908.GE24913@ubuntumail>
References: <CALCETrVSaboa0Y2v_sTbSz3xOxOZ-6jSq_D7DyQXMRB9VXJB8w@mail.gmail.com>
 <87ha5h42va.fsf@x220.int.ebiederm.org>
 <CALCETrX3GjNkhKkST9Nw4sk2ETt=MRUWcc+bNXnGFTXn7ve-ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX3GjNkhKkST9Nw4sk2ETt=MRUWcc+bNXnGFTXn7ve-ww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On Fri, Apr 25, 2014 at 12:37 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> > Andy Lutomirski <luto@amacapital.net> writes:
> >
> >> Unless I'm missing some trick, it's currently rather painful to mount
> >> a namespace /proc.  You have to actually be in the pid namespace to
> >> mount the correct /proc instance, and you can't unmount the old /proc
> >> until you've mounted the new /proc.  This means that you have to fork
> >> into the new pid namespace before you can finish setting it up.
> >
> > Yes.  You have to be inside just about all namespaces before you can
> > finish setting them up.
> >
> > I don't know the context in which needed to be inside the pid namespace
> > is a burden.
> 
> I'm trying to sandbox myself.  I unshare everything, setup up new
> mounts, pivot_root, umount the old stuff, fork, and wait around for
> the child to finish.
> 
> This doesn't work: the parent can't mount the new /proc, and the child
> can't either because it's too late.

I'm probably not thinking it through enough...  But can't the parent, before
forking, do

	mkdir -p /childproc/proc
	mount --bind /childproc /childproc
	mount --make-rshared /childproc

then the child mounts its proc under /childproc/proc and have that show
up in the parent's tree?
