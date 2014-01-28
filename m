Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaA1IPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:15:45 -0500
Received: from mx11.pku.edu.cn ([162.105.129.174]:47682 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754473AbaA1IPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:15:44 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jan 2014 03:15:43 EST
X-Spam-Flag: NO
X-Spam-Score: -307.687
Date: Tue, 28 Jan 2014 16:05:07 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: xypron glpk <xypron.glpk@gmx.de>, gxt@mprc.pku.edu.cn,
        paul gortmaker <paul.gortmaker@windriver.com>, vapier@gentoo.org,
        totglx@linutronix.de, linux-kernel@vger.kernel.org
Message-ID: <182670498.15705.1390896307427.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <20140127134959.72c65d0091554e36d1755ab0@linux-foundation.org>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_[PATCH_1/?=
 =?utf-8?Q?1]_=5F=5Finit_setup=5Fe?=
 =?utf-8?Q?arly=5Fprintk:_missing_initialization?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Andrew Morton <akpm@linux-foundation.org> 写道：
> On Mon, 27 Jan 2014 19:10:24 +0100 xypron.glpk@gmx.de wrote:
> 
> > From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> > 
> > If is based on uninitialized value keep_early.
> > This leads to unpredictable result.
> > 
> > ...
> >
> > --- a/arch/unicore32/kernel/early_printk.c
> > +++ b/arch/unicore32/kernel/early_printk.c
> > @@ -35,7 +35,7 @@ static struct console early_ocd_console = {
> >  
> >  static int __init setup_early_printk(char *buf)
> >  {
> > -	int keep_early;
> > +	int keep_early = 0;
> >  
> >  	if (!buf || early_console)
> >  		return 0;
> 
> yup.
> 
> But that code is quite overcooked.  How about this?
> 
> --- a/arch/unicore32/kernel/early_printk.c~arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix
> +++ a/arch/unicore32/kernel/early_printk.c
> @@ -35,17 +35,11 @@ static struct console early_ocd_console
>  
>  static int __init setup_early_printk(char *buf)
>  {
> -	int keep_early = 0;
> -
>  	if (!buf || early_console)
>  		return 0;
>  
> -	if (strstr(buf, "keep"))
> -		keep_early = 1;
> -
>  	early_console = &early_ocd_console;
> -
> -	if (keep_early)
> +	if (strstr(buf, "keep"))
>  		early_console->flags &= ~CON_BOOT;
>  	else
>  		early_console->flags |= CON_BOOT;
> _
> 

