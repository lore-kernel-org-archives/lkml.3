Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaHHNCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:02:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbaHHNCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:02:14 -0400
From: Paul Moore <pmoore@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jmorris@namei.org
Subject: Re: selinux: fix uninitalised stack variable read in sel_netport_init
Date: Fri, 08 Aug 2014 09:02:08 -0400
Message-ID: <4618967.Wk4B7HAljU@sifl>
Organization: Red Hat
User-Agent: KMail/4.13.3 (Linux/3.15.7-gentoo; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140807163818.GA27618@redhat.com>
References: <20140807163818.GA27618@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 07, 2014 12:38:18 PM Dave Jones wrote:
> After the removal of the avc_add_callback() in commit 615e51fdda6
> ("selinux: reduce the number of calls to synchronize_net() when flushing
> caches"), ret is never set to anything, but we return uninitialized stack
> data on success.
> 
> Given the absense of other failure paths, just explicitly return 0.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Thanks for the patch, but another more comprehensive patch (there are similar 
problems in netnode.c and netif.c) was posted earlier this week and reposted 
last night ... although evidently I need to send the patch(es) directly to 
Linus, so you'll likely see another repost in a few moments.

> diff --git a/security/selinux/netport.c b/security/selinux/netport.c
> index 73ac6784d091..3311cc393cb4 100644
> --- a/security/selinux/netport.c
> +++ b/security/selinux/netport.c
> @@ -237,7 +237,6 @@ void sel_netport_flush(void)
>  static __init int sel_netport_init(void)
>  {
>  	int iter;
> -	int ret;
> 
>  	if (!selinux_enabled)
>  		return 0;
> @@ -247,7 +246,7 @@ static __init int sel_netport_init(void)
>  		sel_netport_hash[iter].size = 0;
>  	}
> 
> -	return ret;
> +	return 0;
>  }
> 
>  __initcall(sel_netport_init);

-- 
paul moore
security and virtualization @ redhat

