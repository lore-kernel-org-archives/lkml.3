Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaIQSYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaIQSYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:24:39 -0400
Date: Wed, 17 Sep 2014 20:22:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        david@fromorbit.com, bmr@redhat.com, jcastillo@redhat.com,
        mguzik@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: Use a seperate wq for do_sync_work() to avoid
	a potential deadlock
Message-ID: <20140917182202.GE19308@redhat.com>
References: <1410953942-32144-1-git-send-email-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410953942-32144-1-git-send-email-atomlin@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17, Aaron Tomlin wrote:
>
> Since do_sync_work() is a deferred function it can block indefinitely by
> design. At present do_sync_work() is added to the global system_wq.
> As such a deadlock is theoretically possible between sys_unmount() and
> sync_filesystems():
>
>   * The current work fn on the system_wq (do_sync_work()) is blocked
>     waiting to aquire a sb's s_umount for reading.
>
>   * The "umount" task is the current owner of the s_umount in
>     question but is waiting for do_sync_work() to continue.
>     Thus we hit a deadlock situation.
>
I can't comment the patches in this area, but I am just curious...

Could you explain this deadlock in more details? I simply can't understand
what "waiting for do_sync_work()" actually means.

> This patch introduces a separate workqueue for do_sync_work() to avoid a
> the described deadlock.

The subject and the changelog do not match the patch, it doesn't add/use
another workqueue.

Oleg.

