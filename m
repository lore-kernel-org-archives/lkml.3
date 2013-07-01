Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3GAN6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:58:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:40586 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab3GAN6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,974,1363158000"; 
   d="scan'208";a="362816024"
Message-ID: <51D18B16.1000402@linux.intel.com>
Date: Mon, 01 Jul 2013 06:58:46 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86, kernel: make dump_pagetables a tristate
References: <20130630040514.GA20587@www.outflux.net>
In-Reply-To: <20130630040514.GA20587@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2013 9:05 PM, Kees Cook wrote:
> Being able to examine page tables is handy, so make this a module that
> can be loaded as needed.

I personally don't think this is a good idea due to the various
security/etc implications of this feature... should really just
be off for non-debug kernels, not "off unless you load the module"


> +#ifdef CONFIG_X86_64
> +EXPORT_SYMBOL_GPL(init_level4_pgt);
> +#else
> +EXPORT_SYMBOL_GPL(swapper_pg_dir);
> +#endif

like these really have no business in any module




