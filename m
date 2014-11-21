Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbaKUCty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:49:54 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41545 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491AbaKUCtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:49:53 -0500
Message-ID: <546EA84A.5070607@hitachi.com>
Date: Fri, 21 Nov 2014 11:49:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/3] kernel: add sysfs documentation for live patching
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-4-git-send-email-sjenning@redhat.com>
In-Reply-To: <1416522580-5593-4-git-send-email-sjenning@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/21 7:29), Seth Jennings wrote:
> Adds sysfs interface documentation to Documentation/ABI/testing/
> 

Hmm, is there any reason to decouple this documentation from code patch?
I think we'd better merge this to 2/3, or move sysfs interface code from 2/3 to this.

Thank you,

> Signed-off-by: Seth Jennings <sjenning@redhat.com>
> ---
>  Documentation/ABI/testing/sysfs-kernel-livepatch | 44 ++++++++++++++++++++++++
>  MAINTAINERS                                      |  1 +
>  2 files changed, 45 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-kernel-livepatch
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
> new file mode 100644
> index 0000000..5bf42a8
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> @@ -0,0 +1,44 @@
> +What:		/sys/kernel/livepatch
> +Date:		Nov 2014
> +KernelVersion:	3.19.0
> +Contact:	live-patching@vger.kernel.org
> +Description:
> +		Interface for kernel live patching
> +
> +		The /sys/kernel/livepatch directory contains subdirectories for
> +		each loaded live patch module.
> +
> +What:		/sys/kernel/livepatch/<patch>
> +Date:		Nov 2014
> +KernelVersion:	3.19.0
> +Contact:	live-patching@vger.kernel.org
> +Description:
> +		The patch directory contains subdirectories for each kernel
> +		object (vmlinux or a module) in which it patched functions.
> +
> +What:		/sys/kernel/livepatch/<patch>/enabled
> +Date:		Nov 2014
> +KernelVersion:	3.19.0
> +Contact:	live-patching@vger.kernel.org
> +Description:
> +		A writable attribute that indicates whether the patched
> +		code is currently applied.  Writing 0 will disable the patch
> +		while writing 1 will re-enable the patch.
> +
> +What:		/sys/kernel/livepatch/<patch>/<object>
> +Date:		Nov 2014
> +KernelVersion:	3.19.0
> +Contact:	live-patching@vger.kernel.org
> +Description:
> +		The object directory contains subdirectories for each function
> +		that is patched within the object.
> +
> +What:		/sys/kernel/livepatch/<patch>/<object>/<function>
> +Date:		Nov 2014
> +KernelVersion:	3.19.0
> +Contact:	live-patching@vger.kernel.org
> +Description:
> +		The function directory contains attributes regarding the
> +		properties and state of the patched function.
> +
> +		There are currently no such attributes.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c7f49ae..7985293 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5725,6 +5725,7 @@ F:	kernel/livepatch/
>  F:	include/linux/livepatch.h
>  F:	arch/x86/include/asm/livepatch.h
>  F:	arch/x86/kernel/livepatch.c
> +F:	Documentation/ABI/testing/sysfs-kernel-livepatch
>  L:	live-patching@vger.kernel.org
>  
>  LLC (802.2)
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


