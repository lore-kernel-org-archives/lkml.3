Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945Ab3E2Bmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:42:52 -0400
Received: from plane.gmane.org ([80.91.229.3]:43097 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932863Ab3E2Bmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:42:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [RFC PATCH v1 0/5] BTRFS hot relocation support
Date: Wed, 29 May 2013 01:42:30 +0000 (UTC)
Message-ID: <pan$8fe1a$e4bf2ee1$b3ce506e$958c8c98@cox.net>
References: <1369062687-23544-1-git-send-email-zwu.kernel@gmail.com>
	<pan$d5913$460afe14$f9be182d$7f8dbe54@cox.net>
	<20130529003815.GE2291@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-231-22-224.ph.ph.cox.net
User-Agent: Pan/0.140 (Chocolate Salty Balls; GIT b00f96e
	/usr/src/portage/src/egit-src/pan2)
Cc: linux-btrfs@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet posted on Tue, 28 May 2013 17:38:15 -0700 as excerpted:

> On Tue, May 21, 2013 at 02:22:34AM +0000, Duncan wrote:
>> zwu.kernel posted on Mon, 20 May 2013 23:11:22 +0800 as excerpted:
>> 
>> > The patchset is trying to introduce hot relocation support for BTRFS.
>> 
>> One advantage of a filesystem implementation, as opposed to bcache or
>> dmcache, is arguably a corner-case, but it's /my/ corner-case, so...
>> 
>> I run an intr*-less (I guess technically, empty initramfs) monolithic-
>> kernel boot [so] any user-space-required-to- mount-root is out [...]
>> 
>> Much like md before it, btrfs, while normally requiring the user-space-
>> required device-scan to properly handle multiple devices, has kernel-
>> command-line options that allow direct kernel multi-device assembly
>> without the help of early-userspace/initr*.

Just a note that while btrfs is /supposed/ to have that functionality, 
I'm actually trying to make it work now, and failing (I can get it to 
work only with rootflags=degraded, which then of course screws the sync 
between the devices, losing the point of multi-device mirroring).  As 
(about a year ago when I brought it up then) someone else (btrfs dev) 
mentioned not being able to get rootflags=dev=... to work on the kernel 
command line with btrfs as well, I assume that functionality is broken 
due to some as yet un-addressed bug, hopefully to be fixed by the time 
btrfs is finally declared stable.  However, that exchange from a year ago 
suggests it's not a particularly high priority...

Meanwhile, I'm working on switching to a very minimal (dracut-based but 
cut WAY down) initramfs now.  Basically only enough to mount the btrfs 
multi-device raid1 mirror since the kernel commandline rootflags method 
appears to be broken, but still with a monolithic kernel, etc, so REALLY 
quite minimal, indeed.  (Once I get the semi-automated dracut host-only 
no-kernel with most-default-modules-omitted version working to give me a 
base pattern to work with, I may well switch to a hand assembled and 
kernel-built initramfs, trimming it down even further.)  Hopefully 
someday the btrfs or rootflags kernel command-line bug will be fixed and 
I can go initr*less again.

So in terms of bcache, for me personally for now, I could in theory add 
it to the minimal initr*.  But there's certainly others running initr*-
less as well, and I'd prefer to be in that class myself once again at 
some point.  (When gentoo devs suggested forcing initr* for the separate /
usr case, users raised QUITE a ruckus, so initr*less may be a minority 
case, but there's still quite a few out there, systemd's universe-
engulfing gray-goo to the contrary or not.)

So there's certainly people out there running initr*less who could make 
use of some sort of hot-data-cache-device functionality, if it's 
available to them.

> I wouldn't be averse to adding such functionality to bcache, provided it
> could be done reasonably cleanly/sensibly. It's not high on my list but
> I'd accept patches :)

Unfortunately I'm more an admin type than coder.  I know my way around a 
Linux system well enough to confidently troubleshoot and trace bugs, but 
for anything other than shell-script, only in the trivial case can I 
actually file an appropriate bugfix patch and feature-patching is right 
out.  So unfortunately, while I'm interested, such a patch can't come 
from me. =:^(

But should anyone else with interest AND the ability be reading... =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

