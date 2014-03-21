Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbaCUQhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:37:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:40188 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463AbaCUQhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:37:46 -0400
Message-ID: <532C6AD8.6000406@windriver.com>
Date: Fri, 21 Mar 2014 10:37:44 -0600
From: Chris Friesen <chris.friesen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: [bug?] can't unmount filesystem after running "exportfs -u" -- dangling
 refcount?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.118.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm seeing some odd behaviour on an NFS server.

We're running 3.4.82 and have a drbd-replicated filesystem 
(active/standby) that is exported via NFS (explicitly v3, and 
/proc/fs/nfsd is mounted).

On a server switchover we take down the NFS server IP address, run 
"exportfs -u" on the exports, unmount the drbd filesystem, and then 
demote drbd from primary to secondary.

The problem we're seeing is that sometimes "exportfs -u" completes 
successfully but "umount" fails with an error that the filesystem is 
busy.  When this happens, "fuser" doesn't see any userspace users, which 
points at the kernel thinking it has a reference open.

When it's in the stuck state, manually running "exportfs -f" seems to 
resolve the issue so that "unmount" can run.

Are there any known issue in this area?

I'm not currently subscribed to the list, so please CC me on replies.

Thanks,
Chris
