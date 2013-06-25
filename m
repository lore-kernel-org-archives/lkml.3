Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3FYI4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:56:35 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56798 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3FYI4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:56:30 -0400
Message-ID: <51C95B3A.10809@numascale-asia.com>
Date: Tue, 25 Jun 2013 16:56:26 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Steffen Persvold <sp@numascale.com>
Subject: 13GB dcache+inode cache hash tables
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As memory capacity increases, we see the dentry and inode cache hash 
tables grow to wild sizes [1], eg 13GB is consumed on a 4.5TB system.

Perhaps a better approach adds a linear component to an exponent to give 
tuned scaling, given that spatial locality is an advantage in hash table 
and careful use of resources.

The same approach would fit to other hash tables (mount-cache, TCP 
established, TCP bind, UDP, UDP-Lite, Dquot-cache) with different 
coefficients, so perhaps we could generalise.

If so what are reasonable reference points and assumptions?

Thanks,
   Daniel

--- [1]

1GB:
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)

8GB:
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)

1TB:
Dentry cache hash table entries: 134217728 (order: 18, 1073741824 bytes)
Inode-cache hash table entries: 67108864 (order: 17, 536870912 bytes)

4.5TB
Dentry cache hash table entries: 1073741824 (order: 21, 8589934592 bytes)
Inode-cache hash table entries: 536870912 (order: 20, 4294967296 bytes)
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
