Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbaCRWRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 18:17:05 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42359 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbaCRWRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 18:17:00 -0400
Date: Tue, 18 Mar 2014 15:16:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eddie.wai@broadcom.com
Subject: Re: [PATCH] rcu: Replace rcu_assign_pointer(x, NULL) with
 RCU_INIT_POINTER(x, NULL) in drivers/input/input.c
Message-ID: <20140318221656.GV4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1395180029-18471-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395180029-18471-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031822-9332-0000-0000-000000278E9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 03:30:29AM +0530, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL) in drivers/input/input.c
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  drivers/input/input.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index da38d97..41b5c82 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -463,7 +463,7 @@ static void __input_release_device(struct input_handle *handle)
>  	struct input_dev *dev = handle->dev;
> 
>  	if (dev->grab == handle) {
> -		rcu_assign_pointer(dev->grab, NULL);
> +		RCU_INIT_POINTER(dev->grab, NULL);
>  		/* Make sure input_pass_event() notices that grab is gone */
>  		synchronize_rcu();
> 
> -- 
> 1.7.9.5
> 

