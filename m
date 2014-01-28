Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaA1UVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:21:39 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:36634 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaA1UVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:21:38 -0500
Message-ID: <52E8114F.7050202@acm.org>
Date: Tue, 28 Jan 2014 14:21:35 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: openipmi-developer@lists.sourceforge.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Add missing rv in ipmi_parisc_probe()
References: <1390936355-11845-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1390936355-11845-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 01:12 PM, Geert Uytterhoeven wrote:
> drivers/char/ipmi/ipmi_si_intf.c: In function 'ipmi_parisc_probe':
> drivers/char/ipmi/ipmi_si_intf.c:2752:2: error: 'rv' undeclared (first use in this function)
> drivers/char/ipmi/ipmi_si_intf.c:2752:2: note: each undeclared identifier is reported only once for each function it appears in
>
> Introduced by commit d02b3709ff8efebfca0612d0ac2a6e31a91c13f4 ("ipmi:
> Cleanup error return")
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Dang it.  Yes, you are right, of course.

Acked-by: Corey Minyard <cminyard@mvista.com>
> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/10537567/
>
>  drivers/char/ipmi/ipmi_si_intf.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 671c3852d359..03f41896d090 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -2724,6 +2724,7 @@ static struct platform_driver ipmi_driver = {
>  static int ipmi_parisc_probe(struct parisc_device *dev)
>  {
>  	struct smi_info *info;
> +	int rv;
>  
>  	info = smi_info_alloc();
>  

