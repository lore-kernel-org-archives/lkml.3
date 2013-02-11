Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3BKMOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:14:34 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:41383 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab3BKMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:14:31 -0500
MIME-Version: 1.0
Date: Mon, 11 Feb 2013 17:44:29 +0530
Message-ID: <CAAYFAvoCi830rc-Y-8scRTLtB0MB1pNYdNq3JrwMr+8ohjkuZA@mail.gmail.com>
Subject: query about create_mnt_ns
From: Rajat Sharma <fs.rajat@gmail.com>
To: linux-fsdevel@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was looking at implementation of init_mount_tree() function and
found a discrepancy in list manipulation of mnt_namsespace and
vfsmount across kernel version 2.6.30. Up till kernel version
2.6.30.x, vfsmount structure was added to the list headed by
mnt_namespace structure just allocated:

list_add(&mnt->mnt_list, &ns->list);

Beyond that with the introduction of function create_mnt_ns(), it does
reverse of previous behavior:

list_add(&new_ns->list, &mnt->mnt_list);

i.e. it is adding new mnt_namespace to the vfsmount list. Is this the
expected behavior? i.e. do we want to maintain list of namespaces per
mount? Please let me know if I am missing something here.

-Rajat
