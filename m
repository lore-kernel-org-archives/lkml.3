Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaG0IWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 04:22:49 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:59313 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaG0IWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 04:22:47 -0400
MIME-Version: 1.0
Date: Sun, 27 Jul 2014 13:52:47 +0530
Message-ID: <CAPb+xgO9_7FQ3NM1NCL8zW5hMzUcWASxu-mk3e64Y+V_DnkMzg@mail.gmail.com>
Subject: "copy_to_user" function not working in stable build "2.6.36.4"
From: zubraz singha <zubrajsingha@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Guys,
While writing a read proc entry for Linux kernel (version 2.6.36.4), I
found that the kernel function "copy_to_user" is not working properly.
The kernel function used internally by "copy_to_user" i.e.
"__copy_to_user" works fine and also this same function "copy_to_user"
works quite well on the higher kernel versions,  I tried it on Linux
kernel version 3.14.  The kernel source code for  "2.6.36.4" doesn't
have a definition for a function i.e "_copy_to_user",  which is being
called internally by "copy_to_user". However the function
"_copy_to_user" has a definition  in higher version kernels like 3.14
etc. I cannot update my kernel,  Is there any way I can fix this issue
by manually patching the kernel. There are two possible ways in which
I think it can be solved.

- Write a definition for the _copy_to_user in "2.6.36.4", which will
have the same "access_ok" check and corresponding  "__copy_to_user"
function call.
- Modifying the function "copy_to_user" and adding the "access_ok"
check and the "__copy_to_user" function.

Zubraj
