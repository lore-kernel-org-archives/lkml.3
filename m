Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbaCRXaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:30:05 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51228 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634AbaCRXaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:30:02 -0400
Date: Tue, 18 Mar 2014 16:29:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eddie.wai@broadcom.com
Subject: Re: [PATCH 4/9] rcu: Replace rcu_assign_pointer(x, NULL) with
 RCU_INIT_POINTER(x, NULL)
Message-ID: <20140318232956.GD4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1395182132.git.monamagarwal123@gmail.com>
 <dfae0194a7fa12d09826ec79bbd7cecd132c7f8d.1395182132.git.monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfae0194a7fa12d09826ec79bbd7cecd132c7f8d.1395182132.git.monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031823-1344-0000-0000-0000005E426B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 04:15:44AM +0530, Monam Agarwal wrote:
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  drivers/net/ppp/pptp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
> index 89f829f..ede899c 100644
> --- a/drivers/net/ppp/pptp.c
> +++ b/drivers/net/ppp/pptp.c
> @@ -162,7 +162,7 @@ static void del_chan(struct pppox_sock *sock)
>  {
>  	spin_lock(&chan_lock);
>  	clear_bit(sock->proto.pptp.src_addr.call_id, callid_bitmap);
> -	rcu_assign_pointer(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
> +	RCU_INIT_POINTER(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
>  	spin_unlock(&chan_lock);
>  	synchronize_rcu();
>  }
> -- 
> 1.7.9.5
> 

