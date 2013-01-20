Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3ATLUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 06:20:45 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:65488 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3ATLUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 06:20:44 -0500
Date: Sun, 20 Jan 2013 20:20:03 +0900
From: Suho Park <suho.hrvatska@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel 3.7.* Problerm
Message-Id: <20130120202003.46105e04704f19f219d6373e@gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.18.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I used the following method since 2.4 version
1. copy .config from the old kernel
2. make oldconfig
(2-1. make dep)
3. make && make modules && make modules_install && make install
and then change the symbolic link of kernel header in /usr/include
to the compiled kernel header.
Works well from 2.4.0 up to 3.6.11

The problem is that 
3.6.11----->3.7.0 is OK
3.7.0 ----->3.7.1 not OK
3.7.1----->3.7.3 not OK

The point is that kerhel header is devided
into two parts linux/include/linux,
linux/include/uapi/linux.

The solution is that I always change the kernel
header includes to point 3.6.11, and compile 3.7.3

There are many applications using linux kernel header,
and I add the following in Makefile
-I/usr/include/uapi, where uapi is symbolically linked to
the kernel/include/uapi, for example I tested netfilter.

Is there any good reason of the division of the kernel headers?
Or is there any good solution?.

-- 
++++++++++++++++++++++++++
Suho Park(suhopark@math.snu.ac.kr)
+82-10-3450-6216
++++++++++++++++++++++++++
