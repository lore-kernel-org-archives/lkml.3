Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686AbaCUOEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:04:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49057 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760353AbaCUOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:04:10 -0400
Message-ID: <532C46D7.9050403@codeaurora.org>
Date: Fri, 21 Mar 2014 10:04:07 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org,
        James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>,
        criu@openvz.org, Eric Dumazet <edumazet@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [CRIU] [PATCH 3/3] tcp: add ability to restore a fin packet
References: <1395408781-8145-1-git-send-email-avagin@openvz.org> <1395408781-8145-4-git-send-email-avagin@openvz.org>
In-Reply-To: <1395408781-8145-4-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 09:33 AM, Andrey Vagin wrote:
> It's required for restoring sockets in closing states:
> TCP_FIN_WAIT{1,2}, TCP_WAIT_STOP, TCP_CLOSING, TCP_LAST_ACK.
> 
> A fin packet is restored by sending a control message (ancillary data).
> In which queue a packet is restored depends on a value of
> tp->repair_queue.
> 
> This interface is choosen, because we are goint to use sendmsg for

Nit: chosen, going

> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -199,4 +199,7 @@ struct tcp_md5sig {
>  	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];		/* key (binary) */
>  };
>  
> +/* Conntroll message types to repair tcp connections */

Nit: Control

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
