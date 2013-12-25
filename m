Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3LYVxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 16:53:00 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:50648 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752199Ab3LYVw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 16:52:58 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Wed, 25 Dec 2013 21:52:49 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: ben@bwidawsk.net, daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix refcount leak and possible NULL pointer
 dereference.
Message-ID: <20131225215249.GA3832@nuc-i3427.alporthouse.com>
References: <201312242050.CGH78112.JQFOSVMLOFtHOF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312242050.CGH78112.JQFOSVMLOFtHOF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 08:50:23PM +0900, Tetsuo Handa wrote:
> >From 482be6384379072eb4c0d45d0ab8a25df4f59ed7 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Tue, 24 Dec 2013 18:04:14 +0900
> Subject: [PATCH] drm/i915: Fix refcount leak and possible NULL pointer dereference.
> 
> Since get_pid_task() grabs a reference on the task_struct, we have to drop the
> refcount after reading that task's comm name. Also, directly reading like
> get_pid_task()->comm can trigger an oops when get_pid_task() returned NULL.

The second issue is moot as file itself cannot exist if the task_struct
is NULL, and the task_struct cannot be destroyed until we finish the
function. The simpler fix would appear to be s/get_pid_task/pid_task/
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
