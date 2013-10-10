Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3JJGqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:46:33 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35746 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3JJGqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:46:30 -0400
Date: Thu, 10 Oct 2013 01:46:26 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
To: Karel Zak <kzak@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <8761tctwhg.fsf@xmission.com> <1381016564.1974.163@driftwood>
	<20131008080303.GH14360@x2.net.home>
In-Reply-To: <20131008080303.GH14360@x2.net.home> (from kzak@redhat.com on
	Tue Oct  8 03:03:03 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1381387586.1974.185@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 03:03:03 AM, Karel Zak wrote:
> On Sat, Oct 05, 2013 at 06:42:44PM -0500, Rob Landley wrote:
> > Oh, attached is a dumb "zapchroot" script I've been using for years  
> to
> > unlink all mount points under a given directory, taking advantage  
> of the
> > fact that mount points are appended to the end of the list so if  
> you unlink
> > from the end to the front you should get the sub-mounts before the  
> parent
> > mounts (modulo mount --move not reordering the list, but that's  
> uncommon).
> 
>  util-linux umount supports --recursive, it uses /proc/self/mountinfo
>  to compose the hierarchy. The important is that the mountinfo file
>  contains Id and Parent_Id relations, so you don't rely on the order
>  only.

Ah, that's what happened.

For some reason /proc/self/mounts stopped adjusting itself for chroot a  
while back, apparently because containers use switch_root instead so  
chroot is generally deprecated or something? This made /proc/mounts  
completely useless in a chroot because the paths it showed were not the  
ones you actually had to use to umount anything.

Instead they added a new way to get this info, in a new format where  
you have to parse the 5th field out of each line to get the mount point  
(to make it friendly to scripts and tools).

Good to know.

Rob