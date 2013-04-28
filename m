Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3D1RGC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 13:06:02 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42779 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3D1RF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 13:05:59 -0400
MIME-Version: 1.0
Date: Sun, 28 Apr 2013 19:05:57 +0200
Message-ID: <CAFLxGvxp+-gt+_dXiAR093psiySE_sD9MA-OdbNUK-AbXQn-pw@mail.gmail.com>
Subject: Modifying an existing mount namespace where user_ns != mnt_ns->user_ns
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

If I create a process with CLONE_NEWNS|CLONE_NEWUSER set, how can I
modify the mount namespace later?

I thought I simply can run setns(/proc/<child>/ns/mnt) within my
privileged process which resists in the initial userns and then mount
whatever I want into the child's mount namespace.
But this fails because do_new_mount() uses current->nsproxy->mnt_ns->user_ns.

--
Thanks,
//richard
