Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaJBNfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:35:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaJBNfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:35:37 -0400
Message-ID: <542D54A7.604@suse.cz>
Date: Thu, 02 Oct 2014 15:35:35 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
CC: sam@ravnborg.org, yamada.m@jp.panasonic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Do not reference *-n variables in the Makefile
References: <20141002221754.3504.AA925319@jp.panasonic.com> <1412256796-4111-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1412256796-4111-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-02 15:33, Michal Marek wrote:
> Kconfig options are either 'y', 'm', or undefined.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  Makefile | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index efbd2cb..106f300 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -868,9 +868,7 @@ vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
>  		     $(net-y) $(net-m) $(libs-y) $(libs-m)))
>  
>  vmlinux-alldirs	:= $(sort $(vmlinux-dirs) $(patsubst %/,%,$(filter %/, \
> -		     $(init-n) $(init-) \
> -		     $(core-n) $(core-) $(drivers-n) $(drivers-) \
> -		     $(net-n)  $(net-)  $(libs-n)    $(libs-))))
> +		     $(init-) $(core-) $(drivers-) $(net-) $(libs-))))

Actually, all the directories are hardcoded in
{init,code,drivers,net,libs}-y; there are currently no Kconfig variables
involved. But let's keep this generic and handle *-m and *- just in case.

Michal
