Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaB0D0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:26:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaB0D0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:26:39 -0500
Message-ID: <1393471595.5519.22.camel@marge.simpson.net>
Subject: Re: 3.13.5 : rm -rf running forever, one cpu at approx 100%
From: Mike Galbraith <bitbucket@online.de>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 27 Feb 2014 04:26:35 +0100
In-Reply-To: <20140227005246.GB10367@milliways>
References: <20140227005246.GB10367@milliways>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:vl/e+0PoaQcjYhycAl1929rFcG34luh+IbBzbNDX3u2
 kktBEE3q5S9y38WTR1JzYuRsimXTjrZ7i9q/AhNy5E3F4nqcuq
 Qe3i/dgH5cwcrJygKUitZlJKCMVal1IVTT+I0B2VAxAjDkDSmO
 7k/89hYZg8aJ3wWvHiOdIJLTg5T11rc1c518F5fK2vn6HnZ8Dj
 tryteTTxN1qS1a3PpaM3l5lnbhU838tjq4G0kakoBvXqWEA/zn
 xtRS9zAG7nD5c9zQO5f1JpJb/r5C+NU2VJwAbhv0Ymrn5V/Tym
 P8hgVF2/zvpYRLSxW097I3Fhg6IUEpdG9/xZRf6hVU9OfVmHur
 Uxaynpf054O9XlautXGxUj4kNucXJ8aAoa4lxF3H/Zryo491Ic
 Sj9qV4A3/mQqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 00:52 +0000, Ken Moffat wrote: 
> Hi,
> 
>  Short summary : on 3.13.5, rm -rf of an application source
> directory on an ext4 filesystem sometimes takes forever (probably
> isn't going anywhere), with one CPU pegged at all-but 100% utilization.
> 
>  I've nearly finished building a new system from source, to check
> various desktop packages in linuxfromscratch.  On this build, much of
> it is things I don't normally use and I needed to upgrade my
> buildscripts, so most of it was built in chroot using 3.10.32.  But
> late last night I booted the new system using 3.13.5 to finish the
> build.  This morning I discovered that rm -rf for the icedtea source
> directory was still running, and had taken over 5 hours of CPU time
> (one CPU seemd to be running at close to 100%, the others had dropped
> to their slowest frequency).  That script was running as root (yeah,
> but it's a new system) and it looks as if /etc/passwd~ had got
> trashed, because I could no longer su or login.  Not sure if that is
> related, at this stage it might just be a side-effect of my scripts.
> 
>  Booted another system, chrooted, fixed up passwords.  Started
> again after commenting out icedtea - I hadn't intended to build
> what was an old version, I'd just forgotten it was in this script -
> that's why I do things in userspace, not the kernel :-(
> 
>  Continued with remaining packages, but a couple of hours later I
> saw a similar "one CPU at 100%, rm -rf GConf source taking forever"
> problem.  Dumped all the processes with Alt-SysRQ-T [ huge log ] but
> at that point 'rm' was merely 'ready' so I doubt there is anything
> useful to see in the log.
> 
>  Built 3.13.4, booted to that.  So far, everything looks good - but
> I'm now building the _current_ version of icedtea, so if this isn't
> a new 3.13.5 problem I guess I'm fairly likely to see it tomorrow.
> 
>  Meanwhile, any suggestions about how I can debug this if I hit it
> again, please ?

I would start with strace to see if a task is looping in userspace, then
move on to perf top -g -p <pid> (or perf record/report) to peek at what
it's up to in the kernel.  Once you have the where, trace_printk() is
the best thing since sliced bread (which ranks just below printk()).

-Mike

