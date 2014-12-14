Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaLNJ4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 04:56:47 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64244 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaLNJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 04:56:46 -0500
Message-ID: <1418551001.14250.25.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/fair: change where we report sched stats
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: bmaurer@fb.com, rkroll@fb.com, kernel-team@fb.com, mingo@redhat.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2014 10:56:41 +0100
In-Reply-To: <5489B07E.9000200@fb.com>
References: <1418149315-30173-1-git-send-email-jbacik@fb.com>
	 <1418192604.5312.28.camel@marge.simpson.net> <5488BFC5.3080001@fb.com>
	 <1418268856.5263.46.camel@marge.simpson.net> <5489B07E.9000200@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 09:55 -0500, Josef Bacik wrote:

> How did you do it?  I had one latency spike in a 90 minute test that 
> runs across 30 boxes that could have been caused by anything, so if 
> there is a way I could have easily found that without moving these 
> tracepoints around I'd love to hear it.  Thanks,

If I have a target, I tend to set tracing_off() traps.

Seems you want an ftrace tracer that tracks sched_switch sleeping to
sched_switch running in addition to the wakeup latency tracer.

-Mike

