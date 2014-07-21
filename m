Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbaGUMs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:48:28 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41976 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaGUMs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:48:27 -0400
Date: Mon, 21 Jul 2014 07:47:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>
Subject: Re: [PATCH 3/3] fuse: Allow mounts from user namespaces
Message-ID: <20140721124725.GB111224@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	lxc-devel@lists.linuxcontainers.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	"Michael H. Warfield" <mhw@wittsend.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
 <1405365496-58404-4-git-send-email-seth.forshee@canonical.com>
 <CAJfpegvMeiZG09U3aXvxKV+GPSn6zFgLbUwXGpTuoVSbnvgfmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvMeiZG09U3aXvxKV+GPSn6zFgLbUwXGpTuoVSbnvgfmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 05:33:23PM +0200, Miklos Szeredi wrote:
> On Mon, Jul 14, 2014 at 9:18 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > Update fuse to allow mounts from user namespaces. During mount
> > current_user_ns() is stashed away,
> 
> Same thing here.  While practically this may work, it's theoretically
> wrong, and possibly may go wrong in special situations.   In fuse
> there's no official "server process", so storing information, like
> namespace, about one is going to be wrong.

What you're suggesting would probably work fine when dealing with pids.
It's not going to work though for the checks I've added in
fuse_allow_current_process() that the process is in the mount owner's
user ns, and without those checks or something similar I don't think
it's safe to permit allow_other for user ns mounts.

I realize that "server process" isn't perfect terminology, it was just
the shorthand I came up with for "the process reading/writing on
/dev/fuse for this super block," which I assumed would be a single
process and certainly not multiple processes in different namespaces.
Can you elaborate on what special situations might violate these
assumptions or otherwise cause problems?

Maybe an alternative approach for the user namspace would be to use the
one which owns the mount namespace of the mount. I'm just not sure off
the top of my head whether or not there's a way for fuse to get to that
information.

