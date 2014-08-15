Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaHOJcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:32:54 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60277 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaHOJcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:32:52 -0400
Message-ID: <53EDD3B9.9070301@gmail.com>
Date: Fri, 15 Aug 2014 17:32:41 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>, tuexen@fh-muenster.de,
        khandelwal.deepak.1987@gmail.com, "Tao, Yue" <Yue.Tao@windriver.com>,
        Alexandre Dietsch <alexandre.dietsch@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, zhuyj <zyjzyj2000@gmail.com>
Subject: Re: SCTP_PEER_ADDR_CHANGE Notification over UNCONFIRMED path
References: <53EDC9AA.9080500@gmail.com>
In-Reply-To: <53EDC9AA.9080500@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. I used attachment to send patch. Maybe it is not convenient. Now 
I resend it again. Please ignore this mail.

Best Regards!
Zhu Yanjun
On 08/15/2014 04:49 PM, zhuyj wrote:
> Hi, Vlad && DEEPAK && Michael && David
>
> From Michael && DEEPAK
> "
>  lxr SCTP implementation, doesn't transit the path state to INACTIVE, 
> if it was never confirmed. this leads to SCTP_PEER_ADDRESS_CHANGE 
> notification after each failed probe from this time.
>  Is there any specific reason to have same notification to SCTP User 
> with each probe in RTO time period ?
>  806 case SCTP_TRANSPORT_DOWN:
>  807 /* If the transport was never confirmed, do not transition it
>  808 * to inactive state. Also, release the cached route since
>  809 * there may be a better route next time.
>  810 */
>  811 if (transport->state != SCTP_UNCONFIRMED)
>
>  812 transport->state = SCTP_INACTIVE;
>
>  http://lxr.free-electrons.com/source/net/sctp/associola.c#L806
>
>  we checked RFC and here it is mentioned as  Path Verification 
> Section(5.4) of RFC 4960  http://tools.ietf.org/html/rfc4960
>
>  In each RTO, a probe may be sent on an active UNCONFIRMED path in an
>  attempt to move it to the CONFIRMED state. If during this probing
>  the path becomes inactive, this rate is lowered to the normal
>  HEARTBEAT rate. At the expiration of the RTO timer, the error
>  counter of any path that was probed but not CONFIRMED is incremented
>  by one and subjected to path failure detection, as defined in
>  Section
>
>
>  8.2
>  . When probing UNCONFIRMED addresses, however, the association
>  overall error counter is not incremented
>
>
>  Does this mean that in attempt to move a UNCONFIRMED path to 
> CONFIRMED State, the path can become INACTIVE, when transport error 
> counter reaches to path_max_retrans counter ?
>  I would say that the path stays UNCONFIRMED.
>
>
>  I would also only expect a  SCTP_PEER_ADDRESS_CHANGE notification 
> when a path state changes, not on every  try.
>
> "
>
> I made a patch to disable sending SCTP_PEER_ADDRESS_CHANGE 
> notification every try. Now the patch is in the attachment. Please 
> check it.
>
> Zhu Yanjun

