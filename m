Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3COEkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:40:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39461 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab3COEkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:40:45 -0400
Date: Fri, 15 Mar 2013 10:10:00 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v2 1/2] [BUGFIX] kprobes: make hash_64() as always
	inlined
Message-ID: <20130315044000.GB31866@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20130314115230.19690.39387.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314115230.19690.39387.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031504-7282-0000-0000-0000152F1483
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 08:52:30PM +0900, Masami Hiramatsu wrote:
> Because hash_64() is called from the get_kprobe() inside
> int3 handler, kernel causes int3 recursion and crashes if
> kprobes user puts a probe on it.
> 
> Usually hash_64() is inlined into caller function, but in
> some cases, it has instances by gcc's interprocedural
> constant propagation.
> 
> This patch uses __always_inline instead of inline to
> prevent gcc from doing such things.
> 
> Changes in v2:
>  - Use __always_inline instead of using __kprobes
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

