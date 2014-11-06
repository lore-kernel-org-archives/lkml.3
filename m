Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaKFUCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:02:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:17212 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751051AbaKFUCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:21 -0500
Date: Thu, 6 Nov 2014 15:02:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141106150204.38c600cf@gandalf.local.home>
In-Reply-To: <1415284748-14648-3-git-send-email-sjenning@redhat.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
	<1415284748-14648-3-git-send-email-sjenning@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Nov 2014 08:39:08 -0600
Seth Jennings <sjenning@redhat.com> wrote:

> --- /dev/null
> +++ b/kernel/livepatch/Kconfig
> @@ -0,0 +1,11 @@
> +config LIVE_PATCHING
> +	tristate "Live Kernel Patching"
> +	depends on DYNAMIC_FTRACE_WITH_REGS && MODULES && SYSFS && KALLSYMS_ALL
> +	default m

Nuke this default. This should be default 'n', which is what kconfig
defaults to when none is mentioned.

-- Steve

> +	help
> +	  Say Y here if you want to support live kernel patching.
> +	  This setting has no runtime impact until a live-patch
> +	  kernel module that uses the live-patch interface provided
> +	  by this option is loaded, resulting in calls to patched
> +	  functions being redirected to the new function code contained
> +	  in the live-patch module.
