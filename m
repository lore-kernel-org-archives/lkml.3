Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaHVVxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:53:47 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54596 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVVxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:53:45 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andreea-Cristina Bernat <bernat.ada@gmail.com>, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v2] carl9170: Remove redundant protection check
Date: Fri, 22 Aug 2014 23:53:40 +0200
Message-ID: <1931285.KsvFbLZH2Q@debian64>
User-Agent: KMail/4.13.3 (Linux/3.17.0-rc1-wl+; KDE/4.14.0; x86_64; ; )
In-Reply-To: <1408741732.5604.23.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20140822191431.GA5827@ada> <1679858.MgakDZE2Vr@debian64> <1408741732.5604.23.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 22, 2014 02:08:52 PM Eric Dumazet wrote:
> On Fri, 2014-08-22 at 22:38 +0200, Christian Lamparter wrote:
> [...]
> > From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> > 
> > The carl9170_op_ampdu_action() function is used only by the mac80211
> > framework. Since the mac80211 already takes care of checks and 
> > properly serializing calls to the driver's function there is no
> > need for the driver to do the same thing.
> >  
> > ---
> > @@ -1430,18 +1430,10 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
> >  		if (!sta_info->ht_sta)
> >  			return -EOPNOTSUPP;
> >  
> > -		rcu_read_lock();
> > -		if (rcu_dereference(sta_info->agg[tid])) {
> > -			rcu_read_unlock();
> > -			return -EBUSY;
> > -		}
> > -
> > [...]
> > ---
> 
> Sorry but this patch is not complete.
> 
> You need to somehow return -EBUSY if sta_info->agg[tid] is set.
The sta_info->agg[tid] check is not needed (for reference, see [0]).
(There is already a check in mac80211 which prevents the leak of
sta_info->agg[tid] [1]).

Regards
Christian

[0] <https://lkml.org/lkml/2014/8/20/725>
[1] <http://lxr.free-electrons.com/source/net/mac80211/agg-tx.c#L583>

