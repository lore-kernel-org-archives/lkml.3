Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab3K0SbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:31:24 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:47949 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab3K0SbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:31:22 -0500
Date: Wed, 27 Nov 2013 13:31:17 -0500
From: Tejun Heo <htejun@gmail.com>
To: zhang.yi20@zte.com.cn
Cc: Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131127183117.GB13098@mtj.dyndns.org>
References: <20131114052326.GA29031@mtj.dyndns.org>
 <20131114114039.GA29277@redhat.com>
 <20131114115551.GA30824@redhat.com>
 <20131114115618.GB30824@redhat.com>
 <CAOS58YO_pZzBB+T6FEzNqfZv4_UUQ_QF1n1zxy4u+H_KhW-vJQ@mail.gmail.com>
 <OF36E72FA9.51146BE3-ON48257C2E.0008BC6D-48257C2E.0008FF9C@zte.com.cn>
 <20131125121416.GB23829@redhat.com>
 <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn>
 <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 10:07:03AM +0800, zhang.yi20@zte.com.cn wrote:
> Userspace process doesn't want the PF_NO_SETAFFINITY, but its parent may be
> a kernel worker thread which has PF_NO_SETAFFINITY set, and this worker thread
> can do kernel_thread() to create the child.
> Clearing this flag in usersapce child to enable its migrating capability.
> 
> 
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>

Acked-by: Tejun Heo <tj@kernel.org>

cc'ing Ingo and Peter.  Ingo, I think this one doesn't really suit the
workqueue tree.  Can you please pick this one up w/ Oleg's ack added
and stable cc'd?  The original patch is

  http://article.gmane.org/gmane.linux.kernel/1602429/raw

Thanks!

-- 
tejun
