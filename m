Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbaCRWQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 18:16:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42515 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbaCRWQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 18:16:30 -0400
Date: Tue, 18 Mar 2014 15:16:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eddie.wai@broadcom.com
Subject: Re: [PATCH] rcu: Replace rcu_assign_pointer(x, NULL) with
 RCU_INIT_POINTER(x, NULL) in drivers/input/endev.c
Message-ID: <20140318221625.GU4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1395179920-18392-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395179920-18392-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031822-0928-0000-0000-0000009502EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 03:28:39AM +0530, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL) in drivers/input/endev.c
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  drivers/input/evdev.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 4cf2534..92e7a3c 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -174,7 +174,7 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
>  	if (evdev->grab != client)
>  		return  -EINVAL;
> 
> -	rcu_assign_pointer(evdev->grab, NULL);
> +	RCU_INIT_POINTER(evdev->grab, NULL);
>  	synchronize_rcu();
>  	input_release_device(&evdev->handle);
> 
> -- 
> 1.7.9.5
> 

