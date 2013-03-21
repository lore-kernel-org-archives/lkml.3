Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3CUUgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:36:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab3CUUgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:36:43 -0400
Date: Thu, 21 Mar 2013 16:36:39 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321203639.GC16406@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130321190653.GA15479@redhat.com>
 <20130321192935.GY21522@ZenIV.linux.org.uk>
 <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
 <20130321202635.GA16406@redhat.com>
 <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 01:32:45PM -0700, Linus Torvalds wrote:
 > On Thu, Mar 21, 2013 at 1:26 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > those are qstr's, so I used d_name.name, right ?
 > 
 > Yup. And if you want to, you could do p1->d_parent->d_name.name too,
 > just to make things obvious. It's technically racy, but by the time
 > the bug happens, who cares?

I'll add that next time around if the current run doesn't turn up anything interesting.
 
 > > I'd be surprised actually, I've got sysfs excluded from its list of victim files,
 > > due to unrelated issues still unresolved.  So unless it followed a symlink into
 > > sys from somewhere in /proc or /dev...
 > >
 > > It took a few hours to reproduce last time, I'll increase the number of child
 > > processes to see if I can trigger it faster now that I have the debug stuff in there.
 > 
 > Hmm, ok. Do you have any network mounts or fuse or other "odd"
 > filesystems etc? The whole "aliased inodes" thing might come from
 > something like that.

at some point during the fuzz run, this happened..

Mar 20 15:20:41 kernel: [ 7578.784674] fuse init (API version 7.21)
Mar 20 15:20:41 systemd[1]: Mounting FUSE Control File System...
Mar 20 15:20:41 systemd[1]: Mounted FUSE Control File System.

I guess something wandered into /dev/fuse and did something. Not sure why 
systemd reacted though...

	Dave

