Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3JaSMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:12:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49383 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3JaSMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:12:13 -0400
Date: Thu, 31 Oct 2013 19:12:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] events: add a flag to perf_event_open() to set O_CLOEXEC
Message-ID: <20131031181202.GA19466@laptop.lan>
References: <cover.1383121137.git.ydroneaud@opteya.com>
 <3b0bc009ff1410d04f8a1e71bfae0d27e1254b90.1383121137.git.ydroneaud@opteya.com>
 <20131030202041.GS16117@laptop.programming.kicks-ass.net>
 <94b641a81a06ba4943cf77e80bc271c8@meuh.org>
 <1383168950-8933-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383168950-8933-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 10:35:50PM +0100, Yann Droneaud wrote:
> This patch adds PERF_FLAG_FD_CLOEXEC flag for
> perf_event_open() syscall.
> 
> perf_event_open() creates a new file descriptor,
> but unlike open() syscall, it lack a flag to atomicaly
> set close-on-exec (O_CLOEXEC).
> 
> Not using O_CLOEXEC by default and not letting userspace
> provide the "open" flags should be avoided: in most case
> O_CLOEXEC must be used to not leak file descriptor across
> exec().
> 
> Using O_CLOEXEC when creating a file descriptor allows
> userspace to set latter, using fcntl(), without any risk
> of race, if the file descriptor is going to be inherited
> or not across exec().
> 
> Link: http://lkml.kernel.org/r/94b641a81a06ba4943cf77e80bc271c8@meuh.org
> Link: http://lkml.kernel.org/r/cover.1383121137.git.ydroneaud@opteya.com
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
> 
> Hi Peter,
> 
> This patch should replaces
> "[PATCH v4 6/7] events: use get_unused_fd_flags(0) instead of get_unused_fd()"
> 
> Please have a look.

I'm still terminally confused as to all of this... Why does it matter
what the default is if you can change it with fcntl() ? Also, how can
you tell nobody relies on the current behaviour and its therefore safe
to change?


