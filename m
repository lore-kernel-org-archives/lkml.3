Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaELIPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:15:52 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:47404 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752621AbaELIPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:15:50 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.336
Date: Mon, 12 May 2014 16:15:43 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Message-ID: <565015395.17555.1399882543611.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <20140506134647.8eae8b38be9e503805168b8f@linux-foundation.org>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_[PATCH_1/1]_?=
 =?utf-8?Q?arch/unicore32/mm/io?=
 =?utf-8?Q?remap.c:_convert_printk/warn=5Fon_to_warn(1?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Andrew Morton <akpm@linux-foundation.org> 写道：
> On Tue, 6 May 2014 19:07:34 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > +coalesce formats
> > 
> > (This is untested)
> > 
> > Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  arch/unicore32/mm/ioremap.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/unicore32/mm/ioremap.c b/arch/unicore32/mm/ioremap.c
> > index 13068ee..5d9568c 100644
> > --- a/arch/unicore32/mm/ioremap.c
> > +++ b/arch/unicore32/mm/ioremap.c
> > @@ -143,13 +143,8 @@ void __iomem *__uc32_ioremap_pfn_caller(unsigned long pfn,
> >  	/*
> >  	 * Don't allow RAM to be mapped
> >  	 */
> > -	if (pfn_valid(pfn)) {
> > -		printk(KERN_WARNING "BUG: Your driver calls ioremap() on\n"
> > -			"system memory.  This leads to architecturally\n"
> > -			"unpredictable behaviour, and ioremap() will fail in\n"
> > -			"the next kernel release. Please fix your driver.\n");
> > -		WARN_ON(1);
> > -	}
> > +	if (pfn_valid(pfn))
> > +		WARN(1, "BUG: Your driver calls ioremap() on\nsystem memory.  This leads to architecturally\nunpredictable behaviour, and ioremap() will fail in\nthe next kernel release. Please fix your driver.\n");
> >  
> 
> I don't think that was an improvement.  Particularly with all
> those \n's in there.
> 
> checkpatch is a just a guide.  It can and should be overruled by common
> sense and taste.
> 
> --- a/arch/unicore32/mm/ioremap.c~arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix
> +++ a/arch/unicore32/mm/ioremap.c
> @@ -144,7 +144,10 @@ void __iomem *__uc32_ioremap_pfn_caller(
>  	 * Don't allow RAM to be mapped
>  	 */
>  	if (pfn_valid(pfn))
> -		WARN(1, "BUG: Your driver calls ioremap() on\nsystem memory.  This leads to architecturally\nunpredictable behaviour, and ioremap() will fail in\nthe next kernel release. Please fix your driver.\n");
> +		WARN(1, "BUG: Your driver calls ioremap() on\n"
> +			"system memory.  This leads to architecturally\n"
> +			"unpredictable behaviour, and ioremap() will fail in\n"
> +			"the next kernel release. Please fix your driver.\n");

A 'return NULL' is also needed to terminate this call.
Febian, could you submit another version?
Thanks.

>  
>  	type = get_mem_type(mtype);
>  	if (!type)
> _
> 

