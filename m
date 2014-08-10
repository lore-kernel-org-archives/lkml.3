Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaHJRZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 13:25:13 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:61633 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaHJRZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 13:25:12 -0400
MIME-Version: 1.0
Date: Sun, 10 Aug 2014 19:25:11 +0200
Message-ID: <CADDKRnDD_W5yJLo2otWXH8oEgmGdMP0N_p7wenBQbh17xKGZJg@mail.gmail.com>
Subject: [proc:] 3.16.0-10436-g9138475: access denied to /proc/1540/task/1540/net/dev
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My network interface eth0 doesn't come up in 3.16.0-10436-g9138475
I am seeing following "security problem" in dmesg:

audit: type=1400 audit(1407684227.003:28): apparmor="DENIED"
  operation="open" profile="/sbin/dhclient"
  name="/proc/1540/task/1540/net/dev" pid=1540 comm="dhclient"
  requested_mask="r" denied_mask="r" fsuid=0 ouid=0

I think the problem is introduced by the following commits, especially
6ba8ed7:

344470c proc: Point /proc/mounts at /proc/thread-self/mounts instead
of /proc/self/mounts
e813244 proc: Point /proc/net at /proc/thread-self/net instead of /proc/self/net
0097875 proc: Implement /proc/thread-self to point at the directory of
the current thread
6ba8ed7 proc: Have net show up under /proc/<tgid>/task/<tid>

To get eth0 activated I need to MODIFY APPARMOR-CONFIGURATION:

e.g.
# Site-specific additions and overrides for sbin.dhclient.
# For more details, please see /etc/apparmor.d/local/README.
/sbin/dhclient {
  @{PROC}/[0-9]*/task/[0-9]*/net/ r,
  @{PROC}/[0-9]*/task/[0-9]*/net/** r
}

Is this interface change to user space intentional?

Thanks,
Jörg
