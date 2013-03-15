Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3COKzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:55:05 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:52741 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3COKzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:55:00 -0400
MIME-Version: 1.0
From: Thomas COUDRAY <amanone@gmail.com>
Date: Fri, 15 Mar 2013 11:54:38 +0100
Message-ID: <CABhRnsWdD6Ef1kg=bud7RKpsQ7KeUhuQEw4Z2N_0RePgS=QDGg@mail.gmail.com>
Subject: lgetxattr()/getxattr() return different values on a file labelled
 with selinux disabled
To: jmorris@namei.org, sds@tycho.nsa.gov, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I encounter trouble that I can't explain when labelling my files.
Here are steps to reproduce (on both 3.2.37 and 3.7.3, with selinux, on
an ext4 fs):
0 - have a regular file "f", with a "before_t" security.selinux attribute
1 - reboot with selinux=0
2 - change the label to "after_t" (setfattr or chcon)
3 - both "ls -Z" (who calls lgetxattr(2)) and "getfattr -n
security.selinux" (who calls getxattr(2)) show "after_t"
4 - reboot with selinux enabled
5 - now ls prints "before_t", and getfattr "after_t".

I ran a small test that calls both syscalls (lgetxattr/getxattr), I
get "before_t" as expected
If I touch /.autorelabel, both ls/getfattr give "before_t".

--
Thomas Coudray
