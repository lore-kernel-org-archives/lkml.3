Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3KNLyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab3KNLya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:54:30 -0500
Date: Thu, 14 Nov 2013 12:55:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: zhang.yi20@zte.com.cn, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 0/1]: (Was: kmod: avoid propagating PF_NO_SETAFFINITY into
	userspace child)
Message-ID: <20131114115551.GA30824@redhat.com>
References: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn> <20131114052326.GA29031@mtj.dyndns.org> <20131114114039.GA29277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114114039.GA29277@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14, Oleg Nesterov wrote:
>
> Yes, but kernel_thread() is called by the worker thread which has
> PF_NO_SETAFFINITY, this flag is copied to child->flags.

Hmm, and it seems that create_worker() needs a minor fix, please see
the patch.

> Looks like Zhang is right... But I'd suggest to change flush_old_exec()
> instead (see "current->flags &= ...").

Yes.


But... May be we should (also?) change copy_flags() to clear
PF_NO_SETAFFINITY? Probably not, this can lead to the subtle behaviour
changes. But I am wondering if there is any kthread() which relies on
PF_NO_SETAFFINITY copied by kernel_thread().

Oleg.

