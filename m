Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaKIUUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 15:20:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKIUUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 15:20:48 -0500
Date: Sun, 9 Nov 2014 12:19:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel: add TAINT_LIVEPATCH
Message-ID: <20141109201922.GB21349@kroah.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-2-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415284748-14648-2-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 08:39:07AM -0600, Seth Jennings wrote:
> This adds a new taint flag to indicate when the kernel or a kernel
> module has been live patched.  This will provide a clean indication in
> bug reports that live patching was used.
> 
> Additionally, if the crash occurs in a live patched function, the live
> patch module will appear beside the patched function in the backtrace.
> 
> Signed-off-by: Seth Jennings <sjenning@redhat.com>
> ---
>  Documentation/oops-tracing.txt  | 2 ++
>  Documentation/sysctl/kernel.txt | 1 +
>  include/linux/kernel.h          | 1 +
>  kernel/panic.c                  | 2 ++
>  4 files changed, 6 insertions(+)
> 
> diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
> index beefb9f..f3ac05c 100644
> --- a/Documentation/oops-tracing.txt
> +++ b/Documentation/oops-tracing.txt
> @@ -270,6 +270,8 @@ characters, each representing a particular tainted value.
>  
>   15: 'L' if a soft lockup has previously occurred on the system.
>  
> + 16: 'K' if the kernel has been live patched.
> +
>  The primary reason for the 'Tainted: ' string is to tell kernel
>  debuggers if this is a clean kernel or if anything unusual has
>  occurred.  Tainting is permanent: even if an offending module is
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index d7fc4ab..085f73b 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -831,6 +831,7 @@ can be ORed together:
>  8192 - An unsigned module has been loaded in a kernel supporting module
>         signature.
>  16384 - A soft lockup has previously occurred on the system.
> +32768 - The kernel has been live patched.
>  
>  ==============================================================
>  
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 446d76a..a6aa2df 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -473,6 +473,7 @@ extern enum system_states {
>  #define TAINT_OOT_MODULE		12
>  #define TAINT_UNSIGNED_MODULE		13
>  #define TAINT_SOFTLOCKUP		14
> +#define TAINT_LIVEPATCH			15
>  
>  extern const char hex_asc[];
>  #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]

Note, this conflicts with a taint value that others are proposing for
something else, so be aware you might run into problems when you hit
linux-next.

thanks,

greg k-h
