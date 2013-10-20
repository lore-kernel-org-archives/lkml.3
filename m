Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab3JTHGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 03:06:35 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:46417 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3JTHGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 03:06:34 -0400
MIME-Version: 1.0
Date: Sun, 20 Oct 2013 15:06:33 +0800
Message-ID: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
Subject: [RFC] Rollback FS
From: jiaweiwei <jiaweiwei.xiyou@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Harry Wei <harryxiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Recently, I just do some stupid stuffs as follows.

# mv /lib/x86_64-linux-gnu/libc.so.6  /tmp

After move "/lib/x86_64-linux-gnu/libc.so.6" away, you could not run lots
of commands, which show you some errors like this.

# ls
ls: error while loading shared libraries: libc.so.6: cannot open
shared object file: No such file or directory
# mv
mv: error while loading shared libraries: libc.so.6: cannot open
shared object file: No such file or directory
...

Because they all depend on libc.so.

You could also happen to above boring stuffs when you remove some key
files in Linux OS. Now, I have a good idea to solve above problems.

We could implement a File System to record all the operations which
send to VFS. Then when you think you have done a mistake command, you
could rollback from this File System.

This is just a RFC, I would give detail implementations. Would anyone
please give me some suggestions? Thanks very much.
