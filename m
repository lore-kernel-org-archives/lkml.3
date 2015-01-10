Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbbAJHiB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 02:38:01 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35054 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbAJHiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 02:38:00 -0500
Message-ID: <1420875475.5283.135.camel@marge.simpson.net>
Subject: Re: sched_yield() call on Linux Kernel 2.6.39 is not behaving
 correct
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yogesh Ahire <yogesh02061983@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 10 Jan 2015 08:37:55 +0100
In-Reply-To: <CAH86sKJnx1wgtkZ-S0QHcRf4dXvSsVoB4U66Yf2vLpruuNeYNA@mail.gmail.com>
References: <CAH86sKKCbZ7CYDEgAnpiVH+7TZNOjziUYOJSWHEpQyY3eUSniA@mail.gmail.com>
	 <1420694794.5279.33.camel@marge.simpson.net>
	 <CAH86sKJJWACmjC0VfF4AHEvsLQ42T81JOYseykzrEB=tVfZQDA@mail.gmail.com>
	 <1420773280.5340.16.camel@marge.simpson.net>
	 <CAH86sKJnx1wgtkZ-S0QHcRf4dXvSsVoB4U66Yf2vLpruuNeYNA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 11:24 -0800, Yogesh Ahire wrote: 
> Thank you Mike. I didn't get what you mean by saying "its gona try to
> yield for one hell of a long time before it succeeds".

Look at vruntimes.  Equalizing same is what the scheduler does for a
living, it does so by giving the CPU to the runnable task with the
lowest vruntime.  Exec time is scaled by load to become vruntime, but
this vruntime delta is so large you may as well just call it infinity.

-Mike

