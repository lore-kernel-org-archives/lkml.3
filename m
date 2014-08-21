Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaHUCGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:06:33 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:58416 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaHUCGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:06:32 -0400
Message-ID: <53F55423.7030902@gmail.com>
Date: Wed, 20 Aug 2014 22:06:27 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zhu Yanjun <zyjzyj2000@gmail.com>, dborkman@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        tuexen@fh-muenster.de, khandelwal.deepak.1987@gmail.com,
        Yue.Tao@windriver.com, alexandre.dietsch@windriver.com,
        davem@davemloft.net
CC: Zhu Yanjun <Yanjun.Zhu@windriver.com>
Subject: Re: [PATCH 1/1] sctp: not send SCTP_PEER_ADDR_CHANGE notifications
 with failed probe
References: <1408527103-22772-1-git-send-email-Yanjun.Zhu@windriver.com> <1408527103-22772-2-git-send-email-Yanjun.Zhu@windriver.com>
In-Reply-To: <1408527103-22772-2-git-send-email-Yanjun.Zhu@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 05:31 AM, Zhu Yanjun wrote:
> Since the transport has always been in state SCTP_UNCONFIRMED, it
> therefore wasn't active before and hasn't been used before, and it
> always has been, so it is unnecessary to bug the user with a 
> notification.
> 
> Reported-by: Deepak Khandelwal <khandelwal.deepak.1987@gmail.com>  
> Suggested-by: Vlad Yasevich <vyasevich@gmail.com> 
> Suggested-by: Michael Tuexen <tuexen@fh-muenster.de>
> Suggested-by: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Thanks
-vlad
> ---
>  net/sctp/associola.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 9de23a2..2e23f6b 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -813,6 +813,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>  		else {
>  			dst_release(transport->dst);
>  			transport->dst = NULL;
> +			ulp_notify = false;
>  		}
>  
>  		spc_state = SCTP_ADDR_UNREACHABLE;
> 

