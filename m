Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaCNN1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:27:38 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:53692 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaCNN1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:27:36 -0400
MIME-Version: 1.0
Date: Fri, 14 Mar 2014 09:27:35 -0400
Message-ID: <CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com>
Subject: [Regression, bisected 9e30cc] "sysfs, kernfs: no need to kern_mount()
 sysfs from sysfs_init()" prevents system from booting correctly
From: Alexandre Demers <alexandre.f.demers@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was told to send this bug
(https://bugzilla.kernel.org/show_bug.cgi?id=72061) directly by email.

So, I've been struggling with something that looks like a bug, but I
may be wrong. Since 3.14-rc1 up until yesterday's latest commit, I
can't boot my system correctly. The kernel will boot, but when it
comes to mounting the disk's partitions, the computer seem to hit
something while mounting the root partition: the light associated to
the disk's activity stays on; if I hit ctrl+alt+del in the first 10 to
15 seconds, the computer will restart; beyond that point, the system
just continues to work on the disk for a long period (I was painting a
door the other day and it continued reading or writing the whole time)
until it begins outputting errors. I'll have to add it in another
comment later. It is about not being able to copy because disk is full
(my partitions have plenty of free space). So I've been bisecting
until I found out when the problem had begun.

------
Bisecting points to the following first bad commit:
9e30cc9595303b27b48be49b7bcd4d0679e34253 is the first bad commit
commit 9e30cc9595303b27b48be49b7bcd4d0679e34253
Author: Tejun Heo <tj@kernel.org>
Date:   Thu Nov 28 14:54:38 2013 -0500

    sysfs, kernfs: no need to kern_mount() sysfs from sysfs_init()

    It has been very long since sysfs depended on vfs to keep track of
    internal states and whether sysfs is mounted or not doesn't make any
    difference to sysfs's internal operation.

    In addition to init and filesystem type registration, sysfs_init()
    invokes kern_mount() to create in-kernel mount of sysfs.  This
    internal mounting doesn't server any purpose anymore.  Remove it.

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 d85991e8a4e333ad651dc593cacff5e6b8d4f916
d3bd9c50967807c9145a7bd9d3ec7978101c93f3 M fs
------

Using any kernel compiled before that commit boots fine. Am I missing something?
