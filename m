Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaHKWlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:41:14 -0400
Received: from senator.holtmann.net ([87.106.208.187]:36578 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaHKWlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:41:12 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] allow setting wiphy.perm_addr after driver probe
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1407791075.28221.74.camel@chimera>
Date: Mon, 11 Aug 2014 15:41:38 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <28066DB2-9EA9-4748-9C89-D3FBD3EC51F5@holtmann.org>
References: <1407780269.28221.63.camel@chimera> <54DF22CF-59D7-4633-A625-896F58C26A64@holtmann.org> <1407789645.28221.68.camel@chimera> <37210DB5-2911-4FA3-9299-7701C5003945@holtmann.org> <1407791075.28221.74.camel@chimera>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

>> The initial wlan0 can be removed as every other netdev attached to the
>> wiphy. It can also be as easily re-created.
>> 
>> Since the wiphy does not have a valid MAC address, my proposal here
>> would be to just not create the wlan0 in the first place. This means
>> that the wiphy can be still discovered via nl80211.
> 
> I repeat, currently wlan0 is *not* created.

what kind of hardware are you actually using here?

>> It also means that the wlan0 netdev needs to be created by userspace
>> now. And a valid NL80211_ATTR_MAC be provided. Similar to what is
>> already done for P2P devices at the moment. That should just solve the
>> problem.
> 
> The creation of wlan0 already comes from userspace, but the PHY has its
> own MAC.
> 
>> We really do not want to announce a netdev when registering the wiphy
>> device and then having to mess with its MAC address via sysfs somehow.
>> This all needs to be properly reflected over RTNL.
>> 
> Again, no netdev is announced. There just isn't a way to set the MAC of
> the wiphy device itself.
> 
> How about this: What if the driver were to leave the MAC at all zeros
> initially, and sysfs could set that if and only if it's all zeros at the
> time?

Internally it might do that, but I do not see it exposing the NL80211_ATTR_MAC when you get the attributes for wiphy.

So I am still saying that when you do NL80211_CMD_NEW_INTERFACE allow providing NL80211_ATTR_MAC to set the MAC address to be used. It might be useful that the wiphy exposes an attribute saying that it does not have a default MAC address, but that should be it. I do not like these magic 00:00:00:00:00:00 games. As I mentioned earlier, in Bluetooth we just deal with allowing the driver to set a flag that it does not have a valid address. And then the core takes care of dealing with it.

Regards

Marcel

