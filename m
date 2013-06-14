Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3FNSyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:54:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab3FNSye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:54:34 -0400
Date: Fri, 14 Jun 2013 14:54:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v5 1/5] vmcore: Introduce ELF header in new memory feature
Message-ID: <20130614185401.GL12023@redhat.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 06:55:57PM +0200, Michael Holzheu wrote:

[..]
> @@ -935,10 +967,17 @@ static int __init vmcore_init(void)
>  {
>  	int rc = 0;
>  
> -	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
> -	if (!(is_vmcore_usable()))
> -		return rc;
> +	/*
> +	 * If elfcorehdr= has not been passed in cmdline, try to get the
> +	 * header from 2nd kernel, then capture the dump.
> +	 */
> +	if (!(is_vmcore_usable())) {
> +		rc = elfcorehdr_alloc();
> +		if (rc)
> +			return rc;
> +	}

Hi Michael,

Patch description says that elfcorehdr_alloc() returns the addr and 
size of elf headers. But that does not seem to be the case here. Has
it been modified in later patches.

Also will it be better if we call elfcorehdr_alloc() always and then
check for is_vmcore_usable().

Something like.

elfcorehdr_addr = elfcorehdr_alloc()
if (elfcorehdr_addr < )
	return elfcorehdr_addr

if (!(is_vmcore_usable()))
	return error

Thanks
Vivek
