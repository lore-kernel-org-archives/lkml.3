Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaCYK6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:58:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:48919 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751067AbaCYK6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:58:18 -0400
Date: Tue, 25 Mar 2014 06:58:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@localhost.localdomain
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 17/26] notifier: Use NOKPROBE_SYMBOL macro in
 notifier
In-Reply-To: <5331593E.7060803@hitachi.com>
Message-ID: <alpine.DEB.2.10.1403250656380.28591@localhost.localdomain>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305120042.22766.48538.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140324161227.6b93b5af@gandalf.local.home> <5331593E.7060803@hitachi.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 25 Mar 2014, Masami Hiramatsu wrote:
> Thanks! I guess since notify_die() is called from any kind of fault,
> which may be happen inside ftrace too.

I see it was added by commit 36dcd67ae, which was when we tried to keep 
ftrace from tracing nmi functions. It is safe to do so now, so that 
notrace can be removed. I'll make a note of that and remove it later :-)

-- Steve

