Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3CGIpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:45:41 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46242
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932120Ab3CGIpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:45:40 -0500
Message-ID: <1362645933.2606.14.camel@laptop>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, chris.mason@fusionio.com
Date: Thu, 07 Mar 2013 09:45:33 +0100
In-Reply-To: <51365B66.5010905@redhat.com>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
	 <513626E9.2040509@redhat.com> <51364AB9.80206@hp.com>
	 <CA+55aFwYOUyG_DQUqVPrQNi_a=AUwS53U-Yi6jbvJTGRxQ_aEQ@mail.gmail.com>
	 <51365B66.5010905@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 15:53 -0500, Rik van Riel wrote:

> Indeed.  Though how well my patches will work with Oracle will
> depend a lot on what kind of semctl syscalls they are doing.
> 
> Does Oracle typically do one semop per semctl syscall, or does
> it pass in a whole bunch at once?

https://oss.oracle.com/~mason/sembench.c

I think Chris wrote that to match a particular pattern of semaphore
operations the database engine in question does. I haven't checked to
see if it triggers the case in point though.

Also, Chris since left Oracle but maybe he knows who to poke.

