Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaE2CJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:09:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbaE2CJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:09:36 -0400
Message-ID: <1401329367.13555.25.camel@localhost>
Subject: Re: [PATCH v2 2/2] audit: Mark CONFIG_AUDITSYSCALL BROKEN and
 update help text
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Philipp Kern <pkern@google.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. J. Lu" <hjl.tools@gmail.com>,
        security@kernel.org, greg@kroah.com, linux-audit@redhat.com
Date: Wed, 28 May 2014 22:09:27 -0400
In-Reply-To: <ff8ecb985119c06510e2c45c078b41cd5df3aaea.1401327752.git.luto@amacapital.net>
References: <cover.1401327752.git.luto@amacapital.net>
	 <ff8ecb985119c06510e2c45c078b41cd5df3aaea.1401327752.git.luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK

On Wed, 2014-05-28 at 18:44 -0700, Andy Lutomirski wrote:
> Here are some issues with the code:
>  - It thinks that syscalls have four arguments.

Not true at all.  It records the registers that would hold the first 4
entries on syscall entry, for use later if needed, as getting those
later on some arches is not feasible (see ia64).  It makes no assumption
about how many syscalls a function has.

>  - It's a performance disaster.

Only if you enable it.  If you don't use audit it is a single branch.
Hardly a disaster.

>  - It assumes that syscall numbers are between 0 and 2048.

There could well be a bug here.  Not questioning that.  Although that
would be patch 1/2

>  - It's unclear whether it's supposed to be reliable.

Unclear to whom?

>  - It's broken on things like x32.
>  - It can't support ARM OABI.

Some arches aren't supported?  And that makes it BROKEN?  

>  - Its approach to freeing memory is terrifying.

What?

None of your reasons hold water.  Bugs need to be fixed.  Try reporting
them...  This is just stupid.

> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  init/Kconfig | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3585b..24d4b53 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -296,13 +296,16 @@ config HAVE_ARCH_AUDITSYSCALL
>  	bool
>  
>  config AUDITSYSCALL
> -	bool "Enable system-call auditing support"
> -	depends on AUDIT && HAVE_ARCH_AUDITSYSCALL
> +	bool "Enable system-call auditing support (not recommended)"
> +	depends on AUDIT && HAVE_ARCH_AUDITSYSCALL && BROKEN
>  	default y if SECURITY_SELINUX
>  	help
> -	  Enable low-overhead system-call auditing infrastructure that
> -	  can be used independently or with another kernel subsystem,
> -	  such as SELinux.
> +	  Enable system-call auditing infrastructure that can be used
> +	  independently or with another kernel subsystem, such as
> +	  SELinux.
> +
> +	  AUDITSYSCALL has serious performance and correctness issues.
> +	  Use it with extreme caution.
>  
>  config AUDIT_WATCH
>  	def_bool y


