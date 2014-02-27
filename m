Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaB0Awu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:52:50 -0500
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:35785
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbaB0Aws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:52:48 -0500
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=Rs1LLUWK c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=M1kyBYkWWGkA:10 a=K7lZiu8yKIQA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=WW6t-I_HNHoA:10
 a=4eSmEAdxL-nunK3z7pAA:9 a=QEXdDO2ut3YA:10
Date: Thu, 27 Feb 2014 00:52:46 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org
Subject: 3.13.5 : rm -rf running forever, one cpu at approx 100%
Message-ID: <20140227005246.GB10367@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 Short summary : on 3.13.5, rm -rf of an application source
directory on an ext4 filesystem sometimes takes forever (probably
isn't going anywhere), with one CPU pegged at all-but 100% utilization.

 I've nearly finished building a new system from source, to check
various desktop packages in linuxfromscratch.  On this build, much of
it is things I don't normally use and I needed to upgrade my
buildscripts, so most of it was built in chroot using 3.10.32.  But
late last night I booted the new system using 3.13.5 to finish the
build.  This morning I discovered that rm -rf for the icedtea source
directory was still running, and had taken over 5 hours of CPU time
(one CPU seemd to be running at close to 100%, the others had dropped
to their slowest frequency).  That script was running as root (yeah,
but it's a new system) and it looks as if /etc/passwd~ had got
trashed, because I could no longer su or login.  Not sure if that is
related, at this stage it might just be a side-effect of my scripts.

 Booted another system, chrooted, fixed up passwords.  Started
again after commenting out icedtea - I hadn't intended to build
what was an old version, I'd just forgotten it was in this script -
that's why I do things in userspace, not the kernel :-(

 Continued with remaining packages, but a couple of hours later I
saw a similar "one CPU at 100%, rm -rf GConf source taking forever"
problem.  Dumped all the processes with Alt-SysRQ-T [ huge log ] but
at that point 'rm' was merely 'ready' so I doubt there is anything
useful to see in the log.

 Built 3.13.4, booted to that.  So far, everything looks good - but
I'm now building the _current_ version of icedtea, so if this isn't
a new 3.13.5 problem I guess I'm fairly likely to see it tomorrow.

 Meanwhile, any suggestions about how I can debug this if I hit it
again, please ?

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
