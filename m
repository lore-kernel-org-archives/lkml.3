Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaE1XJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:09:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34596 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbaE1XJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:09:32 -0400
X-Sasl-enc: 2v6/7clYOXVV7gyZ/Jtf1o9vHZN8Hs5aj93HY9NPM+kE 1401318567
Date: Wed, 28 May 2014 16:13:03 -0700
From: Greg KH <greg@kroah.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Philipp Kern <pkern@google.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. J. Lu" <hjl.tools@gmail.com>,
        Eric Paris <eparis@redhat.com>, security@kernel.org
Subject: Re: [PATCH 2/2] audit: Move CONFIG_AUDITSYSCALL into staging and
 update help text
Message-ID: <20140528231303.GA2737@kroah.com>
References: <cover.1401315521.git.luto@amacapital.net>
 <f6365442194983c2eb0da6ea8c66d1c16441bb2a.1401315521.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6365442194983c2eb0da6ea8c66d1c16441bb2a.1401315521.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 03:21:20PM -0700, Andy Lutomirski wrote:
> Here are some issues with the code:
>  - It thinks that syscalls have four arguments.
>  - It's a performance disaster.
>  - It assumes that syscall numbers are between 0 and 2048.
>  - It's unclear whether it's supposed to be reliable.
>  - It's broken on things like x32.
>  - It can't support ARM OABI.
>  - Its approach to memory allocation is terrifying.
> 
> I considered marking it BROKEN, but that might be too harsh.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  init/Kconfig | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3585b..4584f8a 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -296,13 +296,16 @@ config HAVE_ARCH_AUDITSYSCALL
>  	bool
>  
>  config AUDITSYSCALL
> -	bool "Enable system-call auditing support"
> -	depends on AUDIT && HAVE_ARCH_AUDITSYSCALL
> +	bool "Enable system-call auditing support (not recommended)"
> +	depends on AUDIT && HAVE_ARCH_AUDITSYSCALL && STAGING

As it doesn't actually move any code into drivers/staging/, and I have
no TODO list that needs to be resolved in order to get it out of staging
(other than your list above), I'd prefer it not to take on the STAGING
mark.

But BROKEN is fine with me, that should wake people up to fix it or just
drop it :)

thanks,

greg k-h
