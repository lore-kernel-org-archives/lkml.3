Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaLRQu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:50:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaLRQu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:50:26 -0500
Message-ID: <1418921420.5162.19.camel@localhost>
Subject: Re: linux-next 20141216 BUG: sleeping function called from invalid
 context at mm/slab.c:2849
From: Eric Paris <eparis@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, linux-audit@redhat.com, rgb@redhat.com
Date: Thu, 18 Dec 2014 11:50:20 -0500
In-Reply-To: <5444.1418921116@turing-police.cc.vt.edu>
References: <2966.1418778594@turing-police.cc.vt.edu>
	 <5444.1418921116@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-18 at 11:45 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 16 Dec 2014 20:09:54 -0500, Valdis Kletnieks said:
> 
> > Spotted these two while booting single-user on 20141216.  20141208
> > doesn't throw these, so it's something in the last week or so..
> 
> Gaah!  Turns out that 20141208 *is* susceptible - it had been booting
> just fine for several days, but it went around the bend, apparently due
> to a userspace or initrd change.

$5 says you updated systemd?

Richard?

> egrep 'BUG|Linux vers' from my syslog:
> 
> Dec  9 12:19:53 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec  9 21:19:53 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 10 12:39:45 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 10 20:56:28 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 11 10:46:49 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 11 23:53:10 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 12 11:13:19 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 12 19:26:24 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 12 19:33:32 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 12 19:42:30 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 12 20:00:39 turing-police kernel: [ 1109.635328] BUG: sleeping function called from invalid context at mm/slab.c:2849
> Dec 12 20:00:43 turing-police kernel: [ 1113.680912] BUG: sleeping function called from invalid context at mm/slab.c:2849
> Dec 12 20:33:15 turing-police kernel: [ 3062.345461] BUG: sleeping function called from invalid context at mm/slab.c:2849
> Dec 12 20:37:48 turing-police kernel: [ 3335.788891] BUG: sleeping function called from invalid context at mm/slab.c:2849
> Dec 12 20:41:57 turing-police kernel: [ 3584.265255] BUG: sleeping function called from invalid context at mm/slab.c:2849
> Dec 12 20:42:47 turing-police kernel: [ 3633.863552] BUG: sleeping function called from invalid context at mm/slab.c:2849
> Dec 12 20:51:33 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> Dec 12 21:51:04 turing-police kernel: [ 3587.132867] BUG: sleeping function called from invalid context at mm/slab.c:2849
> Dec 12 22:20:01 turing-police kernel: [ 5322.313024] BUG: sleeping function called from invalid context at mm/slab.c:2849
> Dec 12 23:06:00 turing-police kernel: [ 8077.463289] BUG: sleeping function called from invalid context at mm/slab.c:2849
> Dec 13 00:00:05 turing-police kernel: [11318.405826] BUG: sleeping function called from invalid context at mm/slab.c:2849
> 
> I need to figure out what changed around 7:30PM on the 12th.
> 


