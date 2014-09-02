Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaIBQua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:50:30 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:52123 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbaIBQuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <1409363489.2980.17.camel@localhost>
References: <CA+ydwtoDwQVg_BWrxxdpUyJ7Up60GtxTCLYe_5vFdV2td_kGhQ@mail.gmail.com>
	<CAHA+R7MZCDGRhSf=UuVCGQvNo03wVziZQB_X30rwNf6hmHipQA@mail.gmail.com>
	<20140829195339.GA9780@kria>
	<1409363489.2980.17.camel@localhost>
Date: Tue, 2 Sep 2014 09:50:23 -0700
Message-ID: <CAHA+R7ODa+LrdwSrS7HcBfwwq8_fpj-Ld0OCDtcOqkpCdZCvxg@mail.gmail.com>
Subject: Re: RTNL: assertion failed at net/ipv6/addrconf.c (1699)
From: Cong Wang <cwang@twopensource.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Tommi Rantala <tt.rantala@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 6:51 PM, Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
>
> Also rtnl_lock and rcu_read_lock compose in that order, so we don't need
> to change dev_get_by_flags, but as this is the only user it sure is
> possible. RCU locked version is just easier composeable, so I wouldn't
> touch that if needed in future, just also take rcu lock as before.

There is no point to keep RCU read lock if we have rtnl lock,
I don't know why you don't want to change dev_get_by_flags(),
it is pretty easy to do since it only has one caller.

Even if you really need RCU in future, you are always welcome
to bring it back when you do, sorry we should never be blocked by
code NOT merged yet.

>
> Also we should move ASSERT_RTNL checks from addrconf_join_solict to
> ipv6_dev_mc_inc/dec.
>

Make it another patch.
