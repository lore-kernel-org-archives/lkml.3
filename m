Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3F1Cy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 22:54:56 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:39629 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3F1Cyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 22:54:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130628011843.GD32195@dastard>
References: <20130623143634.GA2000@redhat.com>
	<20130623150603.GA32313@redhat.com>
	<20130623160452.GA11740@redhat.com>
	<20130624155758.GA5993@redhat.com>
	<20130624173510.GA1321@redhat.com>
	<20130625153520.GA7784@redhat.com>
	<20130626191853.GA29049@redhat.com>
	<20130627002255.GA16553@redhat.com>
	<20130627075543.GA32195@dastard>
	<20130627143055.GA1000@redhat.com>
	<20130628011843.GD32195@dastard>
Date: Thu, 27 Jun 2013 16:54:53 -1000
X-Google-Sender-Auth: -Gx31qkP6xvWckAyub7pStVCNjo
Message-ID: <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
Subject: Re: frequent softlockups with 3.10rc6.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 3:18 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Right, that will be what is happening - the entire system will go
> unresponsive when a sync call happens, so it's entirely possible
> to see the soft lockups on inode_sb_list_add()/inode_sb_list_del()
> trying to get the lock because of the way ticket spinlocks work...

So what made it all start happening now? I don't recall us having had
these kinds of issues before..

                Linus
