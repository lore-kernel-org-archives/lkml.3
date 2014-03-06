Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaCFUsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:48:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33111 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaCFUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:48:44 -0500
Date: Thu, 06 Mar 2014 15:48:42 -0500 (EST)
Message-Id: <20140306.154842.1612603056023919814.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 5/6] Drivers: net: hyperv: Enable send side checksum
 offload
From: David Miller <davem@davemloft.net>
In-Reply-To: <d51892af73814794972736463a686a09@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1394104390-23477-5-git-send-email-kys@microsoft.com>
	<20140306.143354.1296864763659469552.davem@davemloft.net>
	<d51892af73814794972736463a686a09@BY2PR03MB299.namprd03.prod.outlook.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 12:48:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KY Srinivasan <kys@microsoft.com>
Date: Thu, 6 Mar 2014 20:29:13 +0000

> 
> 
>> -----Original Message-----
>> From: David Miller [mailto:davem@davemloft.net]
>> Sent: Friday, March 7, 2014 1:04 AM
>> To: KY Srinivasan
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> jasowang@redhat.com
>> Subject: Re: [PATCH 5/6] Drivers: net: hyperv: Enable send side checksum
>> offload
>> 
>> From: "K. Y. Srinivasan" <kys@microsoft.com>
>> Date: Thu,  6 Mar 2014 03:13:09 -0800
>> 
>> > +bool get_net_transport_info(struct sk_buff *skb, bool *is_v4,
>> > +				bool *is_tcp, bool *is_udp, u32 *trans_off) {
>> 
>> Returning so many values like this is awkward, at best.
>> 
>> Why not return a well defined bitmask:
>> 
>> #define TRANSPORT_INFO_SUCCESS	0x00000001
>> #define TRANSPORT_INFO_TCP	0x00000002
>> #define TRANSPORT_INFO_UDP	0x00000004
>> 
>> Then the only value you have to return by reference is trans_off.
> 
> I also need information on the IP version as well. If it is ok with you, I will use the return
> value to get information on the network protocol and return information on transport via
> reference - protocol and the offset.

Just add "TRANSPORT_INFO_IPv4" as another bitmask in the return value.
