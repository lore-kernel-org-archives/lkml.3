Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaB0O4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:56:15 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35234 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaB0O4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:56:13 -0500
MIME-Version: 1.0
In-Reply-To: <1393512787.4648.1.camel@jlt4.sipsolutions.net>
References: <1393512434-1325-1-git-send-email-dh.herrmann@gmail.com>
	<1393512434-1325-3-git-send-email-dh.herrmann@gmail.com>
	<1393512787.4648.1.camel@jlt4.sipsolutions.net>
Date: Thu, 27 Feb 2014 15:56:13 +0100
Message-ID: <CANq1E4RNbtbdVhC2PgyZMGN_duScbmCOGeMxAYiKLL-8H=EWSA@mail.gmail.com>
Subject: Re: [PATCH 2/4] mac80211: set NET_NAME_USER for user-space created ifs
From: David Herrmann <dh.herrmann@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Kay Sievers <kay.sievers@vrfy.org>, Tom Gundersen <teg@jklm.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Feb 27, 2014 at 3:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Given the premise of your patches,
>
>> +++ b/net/mac80211/iface.c
>> @@ -1620,6 +1620,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
>>                                       + IEEE80211_ENCRYPT_HEADROOM;
>>               ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
>>
>> +             ndev->name_assign_type = NET_NAME_USER;
>
> this is wrong because we call this in main.c with a "wlan%d" argument
> for the name, which gets expanded.

Whoops, yeah, same issue as with ath6kl where I fixed it with a
separate "name_assign_type" argument. I will do the same here for v2.

Thanks
David
