Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbbAIDOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:14:45 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:63656 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbbAIDOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:14:44 -0500
X-Greylist: delayed 78485 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 22:14:44 EST
Message-ID: <1420773280.5340.16.camel@marge.simpson.net>
Subject: Re: sched_yield() call on Linux Kernel 2.6.39 is not behaving
 correct
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yogesh Ahire <yogesh02061983@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 09 Jan 2015 04:14:40 +0100
In-Reply-To: <CAH86sKJJWACmjC0VfF4AHEvsLQ42T81JOYseykzrEB=tVfZQDA@mail.gmail.com>
References: <CAH86sKKCbZ7CYDEgAnpiVH+7TZNOjziUYOJSWHEpQyY3eUSniA@mail.gmail.com>
	 <1420694794.5279.33.camel@marge.simpson.net>
	 <CAH86sKJJWACmjC0VfF4AHEvsLQ42T81JOYseykzrEB=tVfZQDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 10:00 -0500, Yogesh Ahire wrote: 
> Thank you Mike. But I can see there are tasks with same priority and
> are runnable waiting for CPU, following is the output of
> /proc/sched_debug where you can see that the task "symphonyapp"
> continuously calls sched_yield() but there are other tasks which are
> ready to run are not getting CPU and are queued back.

Something terminally bad happened.  With that tasks vruntime (tree-key),
it's gonna try to yield for one hell of a long time before it succeeds.

-Mike

