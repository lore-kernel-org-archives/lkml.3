Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaBZNS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:18:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46251 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaBZNS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:18:58 -0500
Date: Wed, 26 Feb 2014 14:18:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, davej@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140226131852.GA22690@pd.tnic>
References: <20140225060146.GA4339@debian.local>
 <530C7465.2080600@zytor.com>
 <20140225162611.GA31902@redhat.com>
 <530CCFD2.3050007@zytor.com>
 <20140226121256.GA8494@debian.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140226121256.GA8494@debian.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 07:12:59PM +0700, Chris Bainbridge wrote:
> @@ -226,6 +234,15 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
>  		clear_cpu_cap(c, X86_FEATURE_SEP);
>  
>  	/*
> +	 * PAE CPUID bug: Pentium M reports no PAE but has PAE
> +	 */
> +	if (forcepae) {
> +		printk(KERN_WARNING "PAE forced!\n");
> +		set_cpu_cap(c, X86_FEATURE_PAE);
> +		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);

This is certainly the wrong taint flag. We'd need a new one or to
repurpose another one as I suggested in a previous mail.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
