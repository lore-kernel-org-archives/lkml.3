Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaFXC2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:28:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:7419 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751132AbaFXC2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:28:06 -0400
Date: Mon, 23 Jun 2014 22:28:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: jbaron@akamai.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH 0/3] static keys: fix test/set races
Message-ID: <20140623222802.4900881c@gandalf.local.home>
In-Reply-To: <cover.1372457176.git.jbaron@akamai.com>
References: <cover.1372457176.git.jbaron@akamai.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cleaning out my INBOX I found this patch series. It seems to have been
forgotten about. It ended up with Ingo and Peter agreeing with the way
things should be done and I thought Jason was going to send an update.
But that seems to never have happened.

Does this patch series still look legit? Should we pursue it?

-- Steve

On Fri, 28 Jun 2013 22:30:28 +0000 (GMT)
jbaron@akamai.com wrote:

> Hi,
> 
> As pointed out by Andi Kleen, some static key users can be racy because they
> check the value of the key->enabled, and then subsequently update the branch
> direction. A number of call sites have 'higher' level locking that avoids this
> race, but the usage in the scheduler features does not. See:
> http://lkml.indiana.edu/hypermail/linux/kernel/1304.2/01655.html
> 
> Thus, introduce a new API that does the check and set under the
> 'jump_label_mutex'. This should also allow to simplify call sites a bit.
> 
> Users of static keys should use either the inc/dec or the set_true/set_false
> API.
> 
> Thanks,
> 
> -Jason
> 
> 
> Jason Baron (3):
>   static_keys: Add a static_key_slow_set_true()/false() interface
>   sched: fix static keys race in sched_feat
>   udp: make use of static_key_slow_set_true() interface
> 
>  Documentation/static-keys.txt |    8 ++++++++
>  include/linux/jump_label.h    |   30 ++++++++++++++++++++++++++++++
>  kernel/jump_label.c           |   40 ++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/core.c           |   12 +++++-------
>  kernel/sched/sched.h          |   10 +++++-----
>  net/ipv4/udp.c                |    9 ++++-----
>  net/ipv6/udp.c                |    9 ++++-----
>  7 files changed, 96 insertions(+), 22 deletions(-)
> 

