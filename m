Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaHFUGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:06:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbaHFUGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:06:48 -0400
Date: Wed, 6 Aug 2014 13:06:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thierry FAUCK - IBM LTC <thierry@linux.vnet.ibm.com>
Cc: avagin@openvz.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Some systems have a dynamic PAGE_SIZE value and do not
 add a definition for PAGE_SIZE. This value will have to be retrieved using
 getpagesize() or sysconf().
Message-Id: <20140806130647.5f94c95c9621dc7d69501641@linux-foundation.org>
In-Reply-To: <1407324866-3548-1-git-send-email-thierry@linux.vnet.ibm.com>
References: <1407324866-3548-1-git-send-email-thierry@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Aug 2014 13:34:26 +0200 Thierry FAUCK - IBM LTC <thierry@linux.vnet.ibm.com> wrote:

> --- a/tools/testing/selftests/ptrace/peeksiginfo.c
> +++ b/tools/testing/selftests/ptrace/peeksiginfo.c
> @@ -31,6 +31,10 @@ static int sys_ptrace(int request, pid_t pid, void *addr, void *data)
>  #define TEST_SICODE_PRIV	-1
>  #define TEST_SICODE_SHARE	-2
>  
> +#ifndef PAGE_SIZE
> +#define PAGE_SIZE sysconf(_SC_PAGESIZE)
> +#endif
> +
>  #define err(fmt, ...)						\
>  		fprintf(stderr,					\
>  			"Error (%s:%d): " fmt,			\

More details, please.  What are "some systems"?
