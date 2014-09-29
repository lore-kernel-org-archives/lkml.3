Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaI2JKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:10:55 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:41877 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaI2JKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:10:52 -0400
MIME-Version: 1.0
Date: Mon, 29 Sep 2014 13:10:50 +0400
Message-ID: <CANaxB-z_h1zDU6Sdj2uAKrK5b_-W4ZWXF4=ti54Rb5QrWPjibQ@mail.gmail.com>
Subject: Does MNT_LOCKED work as expected?
From: Andrey Wagin <avagin@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I think I found a case, when MNT_LOCKED (5ff9d8a65ce8 "vfs: Lock in
place mounts from more privileged users") doesn't help to hide
overmounted parts from unprivileged users.
The problem exists for mounts, which are not overmounted entirely. In
such cases we can open a directory from a target mount, which is not
overmounted. Then we do pivot_root to move all mounts in a temporary
directory. At the final step we deatch all mounts from the temporary
directory. After that all children mounts are umounted from the target
mount and we can use our file descriptor to open files, which have
been overmount before.

Here is a example https://github.com/avagin/userns_vs_mntns.
