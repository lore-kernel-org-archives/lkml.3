Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbaGRIl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:41:57 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:65442 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaGRIlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:41:55 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <20140717.161931.283488873926282207.davem@davemloft.net>
References: <1405584370-30054-1-git-send-email-teg@jklm.no>
 <1405584370-30054-4-git-send-email-teg@jklm.no> <20140717.161931.283488873926282207.davem@davemloft.net>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 18 Jul 2014 10:41:33 +0200
Message-ID: <CAG-2HqVfQtGYmHvFtajxFW-L3WTPd2cdR2Ou2K5DYtEkgmnk-Q@mail.gmail.com>
Subject: Re: [PATCH net-next v9 3/9] net: nl802154 - make add_iface take name
 assign type
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 1:19 AM, David Miller <davem@davemloft.net> wrote:
> From: Tom Gundersen <teg@jklm.no>
> Date: Thu, 17 Jul 2014 10:06:04 +0200
>
>> @@ -192,8 +193,10 @@ int ieee802154_add_iface(struct sk_buff *skb, struct genl_info *info)
>>               if (devname[nla_len(info->attrs[IEEE802154_ATTR_DEV_NAME]) - 1]
>>                               != '\0')
>>                       return -EINVAL; /* phy name should be null-terminated */
>> +             name_assign_type = NET_NAME_USER;
>>       } else  {
>>               devname = "wpan%d";
>> +             name_assign_type = NET_NAME_ENUM;
>>       }
>>
>>       if (strlen(devname) >= IFNAMSIZ)
>
> Just wondering what should happen if "%d" appears in a user provided name.
>
> That would seem to be both USER and ENUM.

Yes, this is a bit of a grey area.

I discussed this a bit with David Herrmann, and we landed on that
these names should be USER. As the user has explicitly asked for the
enumerated name, nobody should rename them to anything else (so ENUM
would have the wrong effect as it indicates that userspace should
rename the device), moreover, we should assume that the user knows
what they are doing, and that the enumerated names are fine in this
context.

Cheers,

Tom
