Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaCaOtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:49:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54360 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaCaOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:49:31 -0400
Date: Mon, 31 Mar 2014 16:49:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org,
        jmorris@namei.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 01/12] Add support for indicating that the booted kernel
 is externally trusted
Message-ID: <20140331144927.GA21805@xo-6d-61-c0.localdomain>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
 <1393445473-15068-2-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393445473-15068-2-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-02-26 15:11:02, Matthew Garrett wrote:
> Provide a boolean runtime configuration option for restricting userspace's
> ability to modify the running kernel. This can be used when some external
> validation of the kernel's state has been performed.

I still don't like the idea, but...

> +Once enabled. trusted kernel support may not be disabled without rebooting
> +the system.

"enabled,"

> @@ -3091,6 +3091,14 @@ static inline void security_audit_rule_free(void *lsmrule)
>  #endif /* CONFIG_SECURITY */
>  #endif /* CONFIG_AUDIT */
>  
> +#ifdef CONFIG_SECURITY_TRUSTED_KERNEL
> +extern bool get_trusted_kernel(void);
> +extern int set_trusted_kernel(bool new_trusted_kernel);
> +#else
> +static inline bool get_trusted_kernel(void) { return 0; }
> +static inline int set_trusted_kernel(bool new_trusted_kernel) { return 0; }
> +#endif /* CONFIG_TRUSTED_KERNEL */

comment does not match ifdef. (And _SECURITY is really superfluous here, maybe shorter
option would be better?)

> +	length = -EINVAL;
> +	if (sscanf(page, "%d", &new_trusted_kernel) != 1)
> +		goto out;
> +
> +	length = set_trusted_kernel(!!new_trusted_kernel);

If someone writes 2 to the sysfs, it would be better to return einval than trying
to second guess him...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
