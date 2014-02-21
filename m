Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbaBUNDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:03:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:64367 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661AbaBUNDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:03:12 -0500
X-IronPort-AV: E=Sophos;i="4.97,518,1389744000"; 
   d="scan'208";a="102968264"
Message-ID: <53074E6C.5080702@citrix.com>
Date: Fri, 21 Feb 2014 13:02:36 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Dan Williams <dcbw@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC v2 2/4] net: enables interface option to skip IP
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com> <1392433180-16052-3-git-send-email-mcgrof@do-not-panic.com> <1392668638.21106.5.camel@dcbw.local> <CAB=NE6XGBp1RwO63W0ac6tTr9JcRM9TB9sap4pa+8PMWwjxu6g@mail.gmail.com> <1392828325.21976.6.camel@dcbw.local> <CAB=NE6VpUqwNNY4pgbS6du2VsZ6dH0TzQYXmiw6GGN-EiOsV6g@mail.gmail.com> <53050244.1020106@citrix.com> <CAB=NE6VswYVF1BOM+vwEh3MaX7sh0gvLqz0U0JoEFDS-EzO9Pg@mail.gmail.com>
In-Reply-To: <CAB=NE6VswYVF1BOM+vwEh3MaX7sh0gvLqz0U0JoEFDS-EzO9Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/02/14 20:39, Luis R. Rodriguez wrote:
> On Wed, Feb 19, 2014 at 11:13 AM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>> On 19/02/14 17:20, Luis R. Rodriguez wrote:
>>>>> On 19/02/14 17:20, Luis R. Rodriguez also wrote:
>>>>> Zoltan has noted though some use cases of IPv4 or IPv6 addresses on
>>>>> backends though <...>
>>>
>>> As discussed in the other threads though there *is* some use cases
>>> of assigning IPv4 or IPv6 addresses to the backend interfaces though:
>>> routing them (although its unclear to me if iptables can be used
>>> instead, Zoltan?).
>>
>> Not with OVS, it steals the packet before netfilter hooks.
>
> Got it, thanks! Can't the route be added using a front-end IP address
> instead on the host though ? I just tried that on a Xen system and it
> seems to work. Perhaps I'm not understand the exact topology on the
> routing case. So in my case I have the backend without any IPv4 or
> IPv6 interfaces, the guest has IPv4, IPv6 addresses and even a TUN for
> VPN and I can create routes on the host to the front end by not using
> the backend device name but instead using the front-end target IP.
Check this how current Xen scripts does routed networking:

http://wiki.xen.org/wiki/Xen_Networking#Associating_routes_with_virtual_devices

Note, there are no bridges involved here! As the above page says, the 
backend has to have IP address, maybe it's not true anymore. I'm not too 
familiar with this setup too, I've used it only once.

Zoli

