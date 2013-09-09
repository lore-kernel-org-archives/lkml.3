Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3IISBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:01:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3IISBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:01:19 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=wom5GMh1gUkA:10 a=zELYHeLyfy0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RfjW8z9EBDgA:10 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=8T59DR07AAAA:8 a=W0vUJOdyAAAA:8 a=pT9tZJnt7dSPHVqia_0A:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=SFncbC_4GEwA:10 a=3Rfx1nUSh_UA:10 a=gv_BBZfBKR8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 14:01:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [16/85] b43: ensue that BCMA is "y" when B43 is "y"
Message-ID: <20130909180115.GC6276@home.goodmis.org>
References: <lsq.1374674564.753305150@decadent.org.uk>
 <lsq.1374674565.595401652@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1374674565.595401652@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 03:02:45PM +0100, Ben Hutchings wrote:
> 3.2.49-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Hauke Mehrtens <hauke@hauke-m.de>
> 
> commit 693026ef2e751fd94d2e6c71028e68343cc875d5 upstream.
> 
> When b43 gets build into the kernel and it should use bcma we have to
> ensure that bcma was also build into the kernel and not as a module.
> In this patch this is also done for SSB, although you can not
> build b43 without ssb support for now.
> 
> This fixes a build problem reported by Randy Dunlap in
> 5187EB95.2060605@infradead.org

Hauke,

Just an FYI, if you find yourself adding message id's as references in
git commits, use the following tag:

Link: http://lkml.kernel.org/r/5187EB95.2060605@infradead.org

-- Steve

> 
> Reported-By: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/wireless/b43/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/net/wireless/b43/Kconfig
> +++ b/drivers/net/wireless/b43/Kconfig
> @@ -28,12 +28,12 @@ config B43
>  
>  config B43_BCMA
>  	bool "Support for BCMA bus"
> -	depends on B43 && BCMA
> +	depends on B43 && (BCMA = y || BCMA = B43)
>  	default y
>  
>  config B43_SSB
>  	bool
> -	depends on B43 && SSB
> +	depends on B43 && (SSB = y || SSB = B43)
>  	default y
>  
>  # Auto-select SSB PCI-HOST support, if possible
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
