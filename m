Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaCDCCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:02:24 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:60030 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbaCDCCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:02:23 -0500
Message-ID: <1393898536.10148.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 6/8] evm: enable key retention service automatically
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
        linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com
Date: Mon, 03 Mar 2014 21:02:16 -0500
In-Reply-To: <43c402f0d4fbcf222f8d669ccf5d237059bd34fe.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	 <43c402f0d4fbcf222f8d669ccf5d237059bd34fe.1393599538.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030402-8236-0000-0000-000000675819
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote: 
> If keys are not enabled, EVM is not visible in the configuration menu.
> It may be difficult to figure out what to do unless  you really know.
> 
> Other subsystems as NFS, CIFS select keys automatically.
> This patch does the same.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/evm/Kconfig | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
> index 5aa9103..d35b491 100644
> --- a/security/integrity/evm/Kconfig
> +++ b/security/integrity/evm/Kconfig
> @@ -1,9 +1,10 @@
>  config EVM
>  	boolean "EVM support"
> -	depends on SECURITY && KEYS && (TRUSTED_KEYS=y || TRUSTED_KEYS=n)

Including KEYS is fine, but the trusted-keys dependency is still
required.  If trusted-keys is enabled, then the TPM and trusted-keys
must be builtin.

Mimi

> +	depends on SECURITY
> +	select KEYS
> +	select ENCRYPTED_KEYS
>  	select CRYPTO_HMAC
>  	select CRYPTO_SHA1
> -	select ENCRYPTED_KEYS
>  	default n
>  	help
>  	  EVM protects a file's security extended attributes against


