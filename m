Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab3ILISt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:18:49 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:55867 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3ILISq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:18:46 -0400
Date: Thu, 12 Sep 2013 03:18:44 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation/kbuild/kconfig.txt: Doesn't make
 listnewconfig replacing yes "" | make oldconfig ?
To: Regid Ichira <regid23@nt1.in>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130912003548.GF8821@nt1.in>
In-Reply-To: <20130912003548.GF8821@nt1.in> (from regid23@nt1.in on Wed Sep
	11 19:35:48 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1378973924.1974.12@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 07:35:48 PM, Regid Ichira wrote:
> Signed-off-by: Regid Ichira <regid23@nt1.in>
> ---
>  Documentation/kbuild/kconfig.txt | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/kbuild/kconfig.txt  
> b/Documentation/kbuild/kconfig.txt
> index 8ef6dbb..14cc40c 100644
> --- a/Documentation/kbuild/kconfig.txt
> +++ b/Documentation/kbuild/kconfig.txt
> @@ -20,16 +20,9 @@ symbols have been introduced.
>  To see a list of new config symbols when using "make oldconfig", use
> 
>  	cp user/some/old.config .config
> -	yes "" | make oldconfig >conf.new
> +	make listnewconfig
> 
> -and the config program will list as (NEW) any new symbols that have
> -unknown values.  Of course, the .config file is also updated with
> -new (default) values, so you can use:
> -
> -	grep "(NEW)" conf.new
> -
> -to see the new config symbols or you can use diffconfig to see the
> -differences between the previous and new .config files:
> +and the config program will list any new symbols, one per line.
> 
>  	scripts/diffconfig .config.old .config | less

Heh. I just make a miniconfig out of both of them and diff those, but  
that got rejected when I tried to push it upstream circa 2006 and I've  
just maintained it locally ever since...

Acked-by: Rob Landley <rob@landley.net>

I'll sit on this for a bit to see if the kbulid guys apply it first,  
and if not forward it through the trivial tree.

Rob