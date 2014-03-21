Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965631AbaCUMyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:54:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:28611 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933337AbaCUMyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:54:31 -0400
Date: Fri, 21 Mar 2014 08:54:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Pavel Shilovsky <piastry@etersoft.ru>, LKML <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Message-ID: <20140321085428.7491f973@gandalf.local.home>
In-Reply-To: <20140321084128.3f499e5c@tlielax.poochiereds.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
	<20140320170239.51d20a0e@tlielax.poochiereds.net>
	<20140320222343.4faaa137@gandalf.local.home>
	<CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
	<20140321081706.271e390c@gandalf.local.home>
	<20140321084128.3f499e5c@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 08:41:28 -0400
Jeff Layton <jlayton@redhat.com> wrote:


> That'd probably work fine too. The main point is to make sure oplock
> breaks run on a different workqueue from where read or write completion
> jobs run since they are operating on the lock_sem. The other jobs that
> get queued to cifsiod_wq don't touch the lock_sem and shouldn't be a
> problem.
> 

OK, I'll take a look at them, and maybe I'll just move the oplock
workqueue. I think you are correct and it may be best to move the one
that takes the lock. Keep that one separate and that will keep the
others from being blocked by it.

Thanks, I'll write something up in a bit.

-- Steve

