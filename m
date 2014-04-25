Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaDYIkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:40:07 -0400
Received: from mail1.windriver.com ([147.11.146.13]:45384 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaDYIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:39:59 -0400
Message-ID: <535A2190.6020801@windriver.com>
Date: Fri, 25 Apr 2014 16:49:20 +0800
From: Xufeng Zhang <xufeng.zhang@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5 ThunderBrowse/3.82
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: <vyasevich@gmail.com>, <nhorman@tuxdriver.com>, <davem@davemloft.net>,
        <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] sctp: reset flowi4_oif parameter on route lookup
References: <1398410978-15954-1-git-send-email-xufeng.zhang@windriver.com> <alpine.LFD.2.11.1404251050490.1969@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.11.1404251050490.1969@ja.home.ssi.bg>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 03:57 PM, Julian Anastasov wrote:
> 	Hello,
>
> On Fri, 25 Apr 2014, Xufeng Zhang wrote:
>
>    
>>
>> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
>> index c09757f..f8a5968 100644
>> --- a/net/sctp/protocol.c
>> +++ b/net/sctp/protocol.c
>> @@ -493,6 +493,10 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>>   		    (AF_INET == laddr->a.sa.sa_family)) {
>>   			fl4->saddr = laddr->a.v4.sin_addr.s_addr;
>>   			fl4->fl4_sport = laddr->a.v4.sin_port;
>> +			/* Reset flowi4_oif so that it won't be incorrectly used
>> +			 * as input parameter to routing lookups.
>> +			 */
>> +			fl4->flowi4_oif = 0;
>>      
> 	May be something like this is more correct:
>
> 			flowi4_update_output(fl4,
> 					     asoc->base.sk->sk_bound_dev_if,
> 					     RT_CONN_FLAGS(asoc->base.sk),
> 					     daddr->v4.sin_addr.s_addr,
> 					     laddr->a.v4.sin_addr.s_addr);
>    

Thanks! you are right, I should use the available API.
I'll send V2 later.


Thanks,
Xufeng


>    
>>   			rt = ip_route_output_key(sock_net(sk), fl4);
>>   			if (!IS_ERR(rt)) {
>>   				dst =&rt->dst;
>>      
> Regards
>
> --
> Julian Anastasov<ja@ssi.bg>
>
>    

