Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3CKVDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:03:55 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52051 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3CKVDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:03:52 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 14:03:51 -0700
Message-ID: <CAA3XVTxhXqo5vJmUjmN1_GPZvftVoNcYGKm1WaVOJTuz3jMNqQ@mail.gmail.com>
Subject: ext4 change in v3.3-rc2 broke user space
From: Bryan Whitehead <driver@megahappy.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifically this change:
http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=d1f5273e9adb40724a85272f248f210dc4ce919a

This change has broken gluster when using ext4 as the backing
filesystem. Details are here:
http://www.gluster.org/2012/08/glusterfs-bit-by-ext4-structure-change/

The change is about a year old now but it is finally making its way
into distribution binaries. As a user it sucks because "ext4" the
"stable" fs basically breaks. Fortunately for myself I've used xfs as
suggested by GlusterFS (older versions stated ext4/ext3 was fine).
However, there are many installs (particularly older installs) that
used ext4 and are finding they must now run outdated old kernels until
they can completely reinstall their gluster cluster with non-ext4
underlying filesystems. Another side effect is users like myself
dealing with the fallout on mailinglists. I've run across this issue
on glusterfs maillinglist (obviously) and also cloudstack. It is so
damn annoying to tell people a kernel change screwed up gluster and
that is why their cluster is busted. To be frank, most will just
assume kernel would never do such a bad thing and it is nonsense that
the kernel is to blame. This sucks.

I'm not hear to bitch (well maybe a little) but I hope changes like
this STOP happening. I think the biggest blame is on RedHat for
backporting the above patch and pushing out kernel binaries before a
workaround in kernel-land was found. On the other hand - a work-around
should have been part of the original patch. I'm resigned to the fact
there is NO hope of this being fixed since everyone has moved on and
it has been accepted for so long. Damnit.

If ext4 is seriously this much in flux - I'd like to politely suggest
it is marked experimental, non-prod, or dangerous.

-Bryan
