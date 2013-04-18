Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967630Ab3DRPuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:50:19 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38354 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966984Ab3DRPuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:50:16 -0400
Date: Thu, 18 Apr 2013 21:19:19 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Fix a double lock bug of
	kprobe_mutex
Message-ID: <20130418154919.GA7877@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20130418093318.13070.29847.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418093318.13070.29847.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041815-7182-0000-0000-0000064CBA81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 06:33:18PM +0900, Masami Hiramatsu wrote:
> Fix a double locking bug caused when debug.kprobe-optimization=0.
> While the proc_kprobes_optimization_handler locks kprobe_mutex,
> wait_for_kprobe_optimizer locks it again and that causes a double lock.
> To fix the bug, this introduces different mutex for protecting
> sysctl parameter and locks it in proc_kprobes_optimization_handler.
> Of course, since we need to lock kprobe_mutex when touching kprobes
> resources, that is done in *optimize_all_kprobes().
> 
> This bug was from ad72b3bea744b4db01c89af0f86f3e8920d354df
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

