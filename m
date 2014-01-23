Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaAWIzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:55:00 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49259 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaAWIy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:54:57 -0500
Message-ID: <52E0D8D8.8040902@gmail.com>
Date: Thu, 23 Jan 2014 16:54:48 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, linux-kernel@vger.kernel.org,
        zhuyj <zyjzyj2000@gmail.com>
Subject: Re: How to identify different ip tunnels
References: <52E0C5B7.7040908@gmail.com>
In-Reply-To: <52E0C5B7.7040908@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The version of the kernel is 3.4.43.

Any reply is appreciated.

Best Regards!
Zhu Yanjun
On 01/23/2014 03:33 PM, zhuyj wrote:
> Hi, Maintainers
>
> We want to identify different ip tunnels.
>
> For example, we use “ip tunnel add xxx” command in linux to create an 
> ipv4/6 tunnel interface,then,we can receive a RTM_NEWLINK message from 
> linux for the new tunnel interface.
> We will parse the struct ifinfomsg message and get the ifi->ifi_type 
> attribute. We need to do somethings depend on the tunnel type here.
> I checked the linux source code and list all the tunnel types here:
>
> #define ARPHRD_TUNNEL 768 /* IPIP tunnel */
> #define ARPHRD_TUNNEL6 769 /* IP6IP6 tunnel */
> #define ARPHRD_SIT 776 /* sit0 device - IPv6-in-IPv4 */
> #define ARPHRD_IPGRE 778 /* GRE over IP */
>
> It means that the linux will report the new link for any ipv4/6 tunnel 
> interface with type only within these four types. However, We need 
> more tunnel types for ipv4/6 tunnel.
> For example, 4IN4/6IN4/6TO4/GRE/ISATAP for ipv4 tunnel and 
> 4IN6/6IN6/IPIN6 for ipv6 tunnel.
>
> Here are the result that we have got:
>
> Actual Tunnel type ifi->ifi_type
> 4IN4 768
> GRE4 778
> 6IN4/6TO4/ISATAP 776
> 4IN6/6IN6/IPIN6 769
>
> So, we can NOT distinguish the actual tunnel type via ifi_type 
> attribute except the GRE4 and 4IN4 tunnel. However we need the actual 
> type. That is our question.
>
> BTW, for the 6IN4 and 6TO4 tunnel, Can we distinguish them before the 
> interface ip address configured? Because we need to do different 
> things for them when we received the new link message and the tunnel 
> has NOT any ip address in this time.
>
> Best Regards!
> Zhu Yanjun
>

