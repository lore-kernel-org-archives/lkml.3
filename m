Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3F3Cpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 22:45:51 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53875 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3F3Cpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 22:45:50 -0400
Date: Sat, 29 Jun 2013 21:45:46 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/5] initmpfs: replace MS_NOUSER in initramfs
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <87y59swg8z.fsf@xmission.com> (from ebiederm@xmission.com on
	Sat Jun 29 20:15:40 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1372560346.2776.158@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2013 08:15:40 PM, Eric W. Biederman wrote:
> Rob Landley <rob@landley.net> writes:
> 
> > From: Rob Landley <rob@landley.net>
> >
> > Mounting MS_NOUSER prevents --bind mounts from rootfs. Prevent new  
> rootfs
> > mounts with a different mechanism that doesn't affect bind mounts.
> 
> I don't see patches 4 and 5 so I don't know if you have covered this
> elsewhere but a very important part of the reason for MS_NOUSER is to
> prevent unmounting of rootfs.

Actually rootfs has separate protections against umounting. I tried  
several varieties of "umount -f /" and "cd /; umount -l .; umount -f  
.." and so on; they're all ignored.

> The entire vfs breaks if you are allowed to unmount rootfs, and it
> appears this patch is allowing that.

Yes, I hit that many moons ago. (Doing either mount --move or  
pivot_root on initramfs, and then umounting it once it was in a  
subdirectory: system locked hard; I can try to dig up a link if you  
like, it was something like 2005? Maybe 2.6.11? It got fixed. This was  
before I implemented switch_root in busybox, because the experience is  
what taught me the difference between pivot_root and switch_root.)

I tested "mount --bind / home" on initmpfs and got "invalid argument".  
(Haven't tried pivot_root again because that binary's not on my test  
system, but when you're _not_ on rootfs that'll kill the system if you  
do it in the global namespace without knowing what you're doing. I can  
specifically test that if you like...)

Rob