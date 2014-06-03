Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386AbaFCX6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:58:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:37951 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932164AbaFCX6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:58:23 -0400
Date: Tue, 3 Jun 2014 19:58:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH ftrace/core 1/2] [BUGFIX] ftrace: Avoid panic when
 allocation of max_buffer is failed
Message-ID: <20140603195821.482551bc@gandalf.local.home>
In-Reply-To: <20140603042803.27308.30956.stgit@yunodevel>
References: <20140603042800.27308.48050.stgit@yunodevel>
	<20140603042803.27308.30956.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As your change log and subject make the bug sound much worse than it
is, I re-wrote both. Here's the new version:

Subject: [PATCH ftrace/core 1/2] [BUGFIX] tracing: Eliminate double free on failure of allocation on boot up

If allocation of the max_buffer fails on boot up, the error path will
free both per_cpu data structures from the buffers. With the new redesign
of the code, those structures are freed if allocations failed. That is,
the helper function that allocates the buffers will free the per cpu data
on failure. No need to do it again. In fact, the second free will cause
a bug as the code can not handle a double free.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---


-- Steve
