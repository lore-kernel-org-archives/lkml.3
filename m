Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab3K1EwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:52:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:24087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab3K1EwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:52:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,788,1378882800"; 
   d="scan'208";a="443493643"
Subject: Re: [PATCH] WIFI: handle a neglected case in
 nl80211_new_interface()
From: Chao Bi <chao.bi@intel.com>
To: Ujjal Roy <royujjal@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1385610818.7437.1.camel@bichao>
References: <1385521254.23222.8.camel@bichao>
	 <CAE2MWk=WEwxbnBDhBRHKVQ7JhAwKANv-HQXyK=qTb4qaH4GZRg@mail.gmail.com>
	 <1385610818.7437.1.camel@bichao>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Nov 2013 13:21:37 +0800
Message-ID: <1385616097.7437.8.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-28 at 11:53 +0800, Chao Bi wrote:
> On Wed, 2013-11-27 at 20:43 +0530, Ujjal Roy wrote:
> > Hi,
> > 
> > 
> > We can use IS_ERR_OR_NULL(wdev) to check NULL as well as error value.
> > 
> > Thanks,
> > UjjaL
> > 
> > On Wed, Nov 27, 2013 at 8:30 AM, Chao Bi <chao.bi@intel.com> wrote:
> >         In nl80211_new_interface(), it calls rdev_add_virtual_intf() to create
> >         a new interface, however, it only checks whether returned value is err
> >         code, but doesn't check if returned value is NULL. The returned 
> 
> Thanks Ujjal. I'll update it.
> 
Hi all,
This patch is not valid, I further check the nl80211 API introduce,
don't need to handle this NULL return value because it bans NULL
feedback of add_virtual_intf() API in cfg80211.h.

