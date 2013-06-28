Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3F1KOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:14:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49330 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3F1KOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:14:02 -0400
Message-ID: <51CD61E3.5040104@6wind.com>
Date: Fri, 28 Jun 2013 12:13:55 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>,
        Sven-Thorsten Dietrich <sven@vyatta.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mike Davison <Mike.Davison@vyatta.com>
Subject: Re: [PATCH] Set the correct RTNL family for multicast netconf messages
References: <1372376687.21767.10.camel@imac-linux.luckyscavenger.com> <20130628012307.GB15799@order.stressinduktion.org> <20130627183342.4b9c5598@nehalam.linuxnetplumber.net> <20130628015121.GC15799@order.stressinduktion.org>
In-Reply-To: <20130628015121.GC15799@order.stressinduktion.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 28/06/2013 03:51, Hannes Frederic Sowa a écrit :
> On Thu, Jun 27, 2013 at 06:33:42PM -0700, Stephen Hemminger wrote:
>> On Fri, 28 Jun 2013 03:23:07 +0200
>> Hannes Frederic Sowa <hannes@stressinduktion.org> wrote:
>>> Hm, are you sure? NETCONFA_MC_FORWARDING is of type RTM_NEWNETCONF
>>> and expects ncm_family to be either AF_INET or AF_INET6 (at least in
>>> iproute2/ipmonitor.c).
>>>
>>
>> I agree with Sven on this, looks like the recent addition of netconf
>> configuration to netlink didn't embrace how multicast is handled in kernel.
>>
>> Multicast forwarding is a routing related configuration value.
>> All the multicast routing events come in as special family RTNL_FAMILY_IPMR
>> (see net/ipv4/ipmr.c function ipmr_fill_route). I would expect that multicast
>> routing daemons would like to be able to use special family to listen for
>> all multicast related changes (and not see non-multicast events).
>>
>>
>> Minor nit: the patch is formatted incorrectly (case should line up with switch).
>
> Yes, this seems reasonable but would need a small update to ipnetconf.c, too.
I also agree with Sven and Stephen.

Note also that the Signed-off-by line is missing in the commit log.

Sven, can you take care of the iproute2 patch? If not, let me know so I can do it.


Thank you,
Nicolas
