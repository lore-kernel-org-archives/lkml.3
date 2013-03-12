Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3CLEfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:35:47 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60025 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab3CLEfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:35:46 -0400
Date: Tue, 12 Mar 2013 10:05:27 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into
	.text.kprobe section
Message-ID: <20130312043526.GA4668@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031204-7182-0000-0000-000005BF65C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:22:33PM +0900, Masami Hiramatsu wrote:
> Beacuse hash_64() is called from the get_kprobe() inside
> int3 handler, kernel causes int3 recursion and crashes if
> kprobes user puts a probe on it.
> 
> Usually hash_64() is inlined into caller function, but in
> some cases, it has instances by gcc's interprocedural
> constant propagation.
> 
> This patch adds __kprobes tag on the hash_64() and moves
> all those instances into .text.kprobe section so that
> kprobes can refuse probing on the instances.
> 
> I've ensured that all hash_64 instances moves to the
> address between __kprobes_text_start and __kprobes_text_end
> with this patch as below.
> 
> ffffffff8138bea0 T __kprobes_text_start
> ffffffff8138bec0 t hash_64.constprop.8
> ffffffff8138ef98 t hash_64.constprop.26
> ffffffff8138efae t hash_64
> ffffffff8138f066 t hash_64.constprop.43
> ffffffff8138f649 t hash_64.constprop.25
> ffffffff8139103a t hash_64.constprop.77
> ffffffff81391050 t hash_64.constprop.24
> ffffffff81391066 t hash_64.constprop.40
> ffffffff8139107c t hash_64.constprop.15
> ffffffff81391092 T __kprobes_text_end
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

