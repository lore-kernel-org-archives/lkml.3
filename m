Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3FNTRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3FNTRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:17:21 -0400
Date: Fri, 14 Jun 2013 15:16:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v5 2/5] s390/vmcore: Use ELF header in new memory feature
Message-ID: <20130614191649.GN12023@redhat.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1370624161-2298-3-git-send-email-holzheu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370624161-2298-3-git-send-email-holzheu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 06:55:58PM +0200, Michael Holzheu wrote:

[..]
>  /*
> - * Create kdump ELF core header in new kernel, if it has not been passed via
> - * the "elfcorehdr" kernel parameter
> + * Free ELF core header (new kernel)
>   */
> -static int setup_kdump_elfcorehdr(void)
> +void elfcorehdr_free(void)
>  {

I was hoping that we will pass the value returned by elfcorehdr_alloc()
here. Something along the lines of kmalloc() and kfree().

elfcorehdr_addr = elfcorhdr_alloc();
...
...
elfcorhdr_free(elfcorhdr_addr);

Only odd part here is that arch will not set elfcorehdr_addr=NULL as there
are functions like is_kdump_kernel() which depend on it being set.

That might be a separate cleanup thought and we can put a comment after
elfcorhdr_free() and explain that oddity.

Thanks
Vivek
