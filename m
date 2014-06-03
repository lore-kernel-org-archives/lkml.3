Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbaFCA4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:56:41 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:63110 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaFCA4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:56:40 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 2 Jun 2014 17:56:19 -0700
Message-ID: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
Subject: 3.15 regression: wrong cgroup magic
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I didn't notice this earlier.  Linux 3.15 breaks my production
system :(  The cause appears to be:

commit 2bd59d48ebfb3df41ee56938946ca0dd30887312
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Feb 11 11:52:49 2014 -0500

    cgroup: convert to kernfs

In particular, this piece:

-       sb->s_magic = CGROUP_SUPER_MAGIC;

The result is that cgroup shows up with the wrong magic number, so my
code goes "oh crap, cgroupfs isn't mounted" and fails.

I can change my code to hack around this, but I can imagine other
things getting tripped up.  Is there still time to fix this?

--Andy
