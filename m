Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3LaPzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 10:55:03 -0500
Received: from mail.candelatech.com ([208.74.158.172]:40687 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3LaPzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 10:55:00 -0500
Message-ID: <52C2E8BA.6000800@candelatech.com>
Date: Tue, 31 Dec 2013 07:54:34 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>  <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>  <1388429761.4410.1.camel@jlt4.sipsolutions.net>  <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6>  <1388438724.4573.2.camel@jlt4.sipsolutions.net>  <20131230215701.GA4938@khazad-dum.debian.net>  <1388445188.18164.0.camel@jlt4.sipsolutions.net> <1388445422.26796.38.camel@joe-AO722> <alpine.DEB.2.02.1312310726540.1930@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1312310726540.1930@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2013 10:32 PM, Julia Lawall wrote:
>>>>> I'm just thinking of a programmer, e.g. changing a struct like this:
>>>>>
>>>>>   struct foo {
>>>>>     u8 addr[ETH_ALEN];
>>>>> -  u16 dummy;
>>>>>   };
>>
>> I don't know of a way to catch that.
>> Anyone else?
>
> Well, one could have a semantic patch that checks for that.  But the
> problem is that it is very slow, and it only covers the cases that I can
> transform automatically, which currently means no pointers, only explicit
> arrays.
>
> On the other hand, I am finding the structure definition, so I can easily
> update the structure definition with an appropriate comment.
>
> struct foo {
>      u8 addr[ETH_ALEN]; /* must be followed by two bytes in the structure */
>      u16 dummy;
> };
>
> Unfortunately it is kind of verbose.  Could there be an attribute?  That
> could even easily be checked.

Can you not just add a build-time macro to check that sizeof(foo) >= 8
for each of these struct foos?  Or, is it required that the dummy field
be there and be not used by anything else?

Thanks,
Ben

>
> julia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

