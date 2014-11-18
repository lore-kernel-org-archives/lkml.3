Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbaKRXLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:11:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55499 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932746AbaKRXLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:11:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] kernel-power: Deletion of an unnecessary check before the function call "vfree"
Date: Wed, 19 Nov 2014 00:32:07 +0100
Message-ID: <3338798.z9fqSjyBWX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5468A677.1030004@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <5317A59D.4@users.sourceforge.net> <5468A677.1030004@users.sourceforge.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 16, 2014 02:28:23 PM SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 16 Nov 2014 14:18:28 +0100
> 
> The vfree() function performs also input parameter validation. Thus the test
> around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Queued up for 3.19-rc1, thanks!

> ---
>  kernel/power/swap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index aaa3261..337c7a9 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -1374,7 +1374,7 @@ out_clean:
>  				kthread_stop(data[thr].thr);
>  		vfree(data);
>  	}
> -	if (page) vfree(page);
> +	vfree(page);
>  
>  	return ret;
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
