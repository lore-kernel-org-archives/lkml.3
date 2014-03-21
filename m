Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaCUVoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:44:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:40802 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751171AbaCUVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:44:07 -0400
Date: Fri, 21 Mar 2014 17:44:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 02/26] kprobes/x86: Allow to handle reentered
 kprobe on singlestepping
Message-ID: <20140321174400.581551a2@gandalf.local.home>
In-Reply-To: <20140305115857.22766.61414.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115857.22766.61414.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 20:58:57 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Since the NMI handlers(e.g. perf) can interrupt in the
> single stepping (or preparing the single stepping, do_debug
> etc.), we should consider a kprobe is hit in the NMI
> handler. Even in that case, the kprobe is allowed to be
> reentered as same as the kprobes hit in kprobe handlers
> (KPROBE_HIT_ACTIVE or KPROBE_HIT_SSDONE).
> The real issue will happen when a kprobe hit while another
> reentered kprobe is processing (KPROBE_REENTER), because
> we already consumed a saved-area for the previous kprobe.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
