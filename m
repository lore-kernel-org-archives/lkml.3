Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3FJNfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:35:32 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:52401 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3FJNfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com>
Date: Mon, 10 Jun 2013 22:35:30 +0900
Message-ID: <CABOkKT33diYR+7Nt9HdRxxqnb1KGkUz8YLTjGODsv2s5vj+3og@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] vmcore: Introduce ELF header in new memory feature
From: HATAYAMA Daisuke <d.hatayama@gmail.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/8 Michael Holzheu <holzheu@linux.vnet.ibm.com>:
<cut>
> @@ -935,10 +967,17 @@ static int __init vmcore_init(void)
>  {
>         int rc = 0;
>
> -       /* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
> -       if (!(is_vmcore_usable()))
> -               return rc;
> +       /*
> +        * If elfcorehdr= has not been passed in cmdline, try to get the
> +        * header from 2nd kernel, then capture the dump.
> +        */
> +       if (!(is_vmcore_usable())) {
> +               rc = elfcorehdr_alloc();
> +               if (rc)
> +                       return rc;
> +       }

Here you removed comment in the 1st path. Please keep it.

Thanks.
HATAYAMA, Daisuke
