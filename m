Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbaLMBSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 20:18:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:14881 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932599AbaLMBS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 20:18:29 -0500
Message-ID: <1418433507.3683.0.camel@goodmis.org>
Subject: Re: [Resend][PATCH] tracing / PM: Replace CONFIG_PM_RUNTIME with
 CONFIG_PM
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Fri, 12 Dec 2014 20:18:27 -0500
In-Reply-To: <2199353.4ffnTtchId@vostro.rjw.lan>
References: <1729515.GUkTny2h5Y@vostro.rjw.lan>
	 <2199353.4ffnTtchId@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-12-13 at 02:34 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so files that are
> build conditionally if CONFIG_PM_RUNTIME is set may now be build
> if CONFIG_PM is set.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in kernel/trace/Makefile
> for this reason.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Please let me know if there are any objections against this.  If not, I'll
> take it through the linux-pm tree, as I'm going to remove CONFIG_PM_RUNTIME
> entirely shortly.

Feel free to take it.

Acked-by: Steven Rostedt <rostedt@goodmis.org.

-- Steve

> 
> ---
>  kernel/trace/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-pm/kernel/trace/Makefile
> ===================================================================
> --- linux-pm.orig/kernel/trace/Makefile
> +++ linux-pm/kernel/trace/Makefile
> @@ -55,7 +55,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_eve
>  obj-$(CONFIG_EVENT_TRACING) += trace_events_trigger.o
>  obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
>  obj-$(CONFIG_TRACEPOINTS) += power-traces.o
> -ifeq ($(CONFIG_PM_RUNTIME),y)
> +ifeq ($(CONFIG_PM),y)
>  obj-$(CONFIG_TRACEPOINTS) += rpm-traces.o
>  endif
>  ifeq ($(CONFIG_TRACING),y)


