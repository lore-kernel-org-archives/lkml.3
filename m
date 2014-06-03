Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176AbaFCVff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:35:35 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35523 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047AbaFCVfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:35:34 -0400
Date: Tue, 3 Jun 2014 14:35:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        joseph.salisbury@canonical.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: [PATCH] kthread: Fix return value of kthread_create() upon
 SIGKILL.
In-Reply-To: <201406032203.ECD00030.OOHFSQtVFLOFMJ@I-love.SAKURA.ne.jp>
Message-ID: <alpine.DEB.2.02.1406031434540.19491@chino.kir.corp.google.com>
References: <53236AA2.7030105@canonical.com> <20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org> <20140317201919.GA28997@redhat.com> <201406032203.ECD00030.OOHFSQtVFLOFMJ@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014, Tetsuo Handa wrote:

> >From c41fa0b9294900a86167d6c8db392d99dde09774 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Tue, 3 Jun 2014 21:46:24 +0900
> Subject: [PATCH] kthread: Fix return value of kthread_create() upon SIGKILL.
> 
> Commit 786235eeb "kthread: make kthread_create() killable" meant for
> allowing kthread_create() to abort as soon as killed by the OOM-killer.
> But returning -ENOMEM is wrong if killed by SIGKILL from userspace.
> Change kthread_create() to return -EINTR upon SIGKILL.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: stable <stable@kernel.org> [3.13+]

Acked-by: David Rientjes <rientjes@google.com>
