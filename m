Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaCVAx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 20:53:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:28621 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750987AbaCVAxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 20:53:25 -0400
Date: Fri, 21 Mar 2014 20:53:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, fche@redhat.com, mingo@redhat.com,
        systemtap@sourceware.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH -tip v8 06/26] [BUGFIX] x86: Prohibit probing on
 native_set_debugreg/load_idt
Message-ID: <20140321205319.02dc33f4@gandalf.local.home>
In-Reply-To: <20140305115925.22766.31964.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115925.22766.31964.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 20:59:25 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Prohibit probing on native_set_debugreg and native_load_idt.
> Since the kprobes uses do_debug for single stepping,
> functions called from do_debug before notify_die must not
> be probed.
> And also native_load_idt is called from paranoid_exit when
> returning int3, this also must not be probed.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
