Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaL3N0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 08:26:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaL3N0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 08:26:03 -0500
Date: Tue, 30 Dec 2014 14:26:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: fanotify: might_sleep() warning in fanotify_read()
Message-ID: <alpine.LNX.2.00.1412301422520.31609@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

current Linus' tree is giving me

WARNING: CPU: 0 PID: 310 at kernel/sched/core.c:7303 __might_sleep+0x8d/0xa0()
do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff810904da>] prepare_to_wait+0x2a/0x90

which is because fanotify_read() is doing this:

	prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
	mutex_lock(&group->notification_mutex);

i.e. calls mutex_lock() while it's already TASK_INTERRUPTIBLE.

-- 
Jiri Kosina
SUSE Labs
