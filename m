Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaB0B2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:28:33 -0500
Received: from mail.wdtv.com ([66.118.69.84]:56541 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbaB0B2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:28:32 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: 3.13.5 : rm -rf running forever, one cpu at approx 100%
Date: Wed, 26 Feb 2014 20:28:29 -0500
References: <20140227005246.GB10367@milliways>
In-Reply-To: <20140227005246.GB10367@milliways>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 8bit
Message-Id: <201402262028.29352.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Ken Moffat wrote:
>Hi,
>
> Short summary : on 3.13.5, rm -rf of an application source
>directory on an ext4 filesystem sometimes takes forever (probably
>isn't going anywhere), with one CPU pegged at all-but 100% utilization.
>
> I've nearly finished building a new system from source, to check
>various desktop packages in linuxfromscratch.  On this build, much of
>it is things I don't normally use and I needed to upgrade my
>buildscripts, so most of it was built in chroot using 3.10.32.  But
>late last night I booted the new system using 3.13.5 to finish the
>build.  This morning I discovered that rm -rf for the icedtea source
>directory was still running, and had taken over 5 hours of CPU time
>(one CPU seemd to be running at close to 100%, the others had dropped
>to their slowest frequency).  That script was running as root (yeah,
>but it's a new system) and it looks as if /etc/passwd~ had got
>trashed, because I could no longer su or login.  Not sure if that is
>related, at this stage it might just be a side-effect of my scripts.
>
> Booted another system, chrooted, fixed up passwords.  Started
>again after commenting out icedtea - I hadn't intended to build
>what was an old version, I'd just forgotten it was in this script -
>that's why I do things in userspace, not the kernel :-(
>
> Continued with remaining packages, but a couple of hours later I
>saw a similar "one CPU at 100%, rm -rf GConf source taking forever"
>problem.  Dumped all the processes with Alt-SysRQ-T [ huge log ] but
>at that point 'rm' was merely 'ready' so I doubt there is anything
>useful to see in the log.
>
> Built 3.13.4, booted to that.  So far, everything looks good - but
>I'm now building the _current_ version of icedtea, so if this isn't
>a new 3.13.5 problem I guess I'm fairly likely to see it tomorrow.
>
> Meanwhile, any suggestions about how I can debug this if I hit it
>again, please ?
>
>ĸen

I don't have any help to offer Ken, but this walks and quacks much like a 
duck I'm encountering in 3.13.5, with the backup program amanda, which uses 
gnu tar.  To facilitate intelligent guesses as to the size of the various 
levels of backup, amanda does a dummy collection using tar, sent to 
/dev/null, using only the size it reports on the first pass.  Version 1.22, 
quite old, works on 3.12.9, but not on 3.13.5.  I have now pulled in, built 
and installed tar-1.27, and rebuilt amanda to let it know that the tar its 
using is not in /usr/bin, but in /usr/local/bin.  Next run at 1:30AM

This freeze, using 100% of a core, but causing no visible disk activity has 
killed my backups 3 nights running.  At this point I've no clue as to the 
cause, but I will be watching this thread closely, it has a similar 
description.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

