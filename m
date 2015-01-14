Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbbANUc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:32:28 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:54506 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbbANUcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:32:05 -0500
Message-ID: <54B6D241.6070700@xs4all.net>
Date: Wed, 14 Jan 2015 21:32:01 +0100
From: Miquel van Smoorenburg <mikevs@xs4all.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: stable@kernel.org
Subject: net: prevent of emerging cross-namespace symlinks patches for 3.14
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running 'lxc' on the latest -stable kernel, 3.14.28, I'm seeing 
these errors:

Jan 14 17:47:16 lxc2 kernel: [   10.704890] WARNING: CPU: 0 PID: 3209 at 
fs/sys
fs/dir.c:52 sysfs_warn_dup+0x8c/0xb0()
Jan 14 17:47:16 lxc2 kernel: [   10.704892] sysfs: cannot create 
duplicate filename '/devices/virtual/net/eth0.104/upper_eth0'
Jan 14 17:47:16 lxc2 kernel: [   10.704954] CPU: 0 PID: 3209 Comm: 
lxc-autostart Not tainted 3.14.28-xsserver #1

I did not see these errors in 3.12. This was fixed in 3.17 by:

net: prevent of emerging cross-namespace symlinks
https://github.com/torvalds/linux/commit/4c75431ac3520631f1d9e74aa88407e6374dbbc4

net: fix creation adjacent device symlinks
https://github.com/torvalds/linux/commit/7ce64c79c4decdeb1afe0bf2f6ef834b382871d1

These patches apply cleanly to 3.14.28. I think this should go into 
3.14-stable.

Thanks,

Mike.
