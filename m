Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaB0QSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:18:44 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:35217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaB0QSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:18:41 -0500
Message-ID: <1393517912.4648.5.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 2/4] mac80211: set NET_NAME_USER for user-space created
 ifs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Kay Sievers <kay.sievers@vrfy.org>, Tom Gundersen <teg@jklm.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 27 Feb 2014 17:18:32 +0100
In-Reply-To: <CANq1E4RNbtbdVhC2PgyZMGN_duScbmCOGeMxAYiKLL-8H=EWSA@mail.gmail.com> (sfid-20140227_155615_730008_8D7E77AA)
References: <1393512434-1325-1-git-send-email-dh.herrmann@gmail.com>
	 <1393512434-1325-3-git-send-email-dh.herrmann@gmail.com>
	 <1393512787.4648.1.camel@jlt4.sipsolutions.net>
	 <CANq1E4RNbtbdVhC2PgyZMGN_duScbmCOGeMxAYiKLL-8H=EWSA@mail.gmail.com>
	 (sfid-20140227_155615_730008_8D7E77AA)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 15:56 +0100, David Herrmann wrote:

> >> +++ b/net/mac80211/iface.c
> >> @@ -1620,6 +1620,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
> >>                                       + IEEE80211_ENCRYPT_HEADROOM;
> >>               ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
> >>
> >> +             ndev->name_assign_type = NET_NAME_USER;
> >
> > this is wrong because we call this in main.c with a "wlan%d" argument
> > for the name, which gets expanded.
> 
> Whoops, yeah, same issue as with ath6kl where I fixed it with a
> separate "name_assign_type" argument. I will do the same here for v2.

I'm not sure that helps - the user could potentially pass "foobar%d" as
the interface name and get a number assigned by the kernel. In that case
you probably *don't* want to set it to "name assigned by user"?

Maybe this whole thing can just be handled in __dev_alloc_name() since
no kernel user should pass just a string without "%d" in it.

johannes

