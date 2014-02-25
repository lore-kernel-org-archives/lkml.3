Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaBYTvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:51:01 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:40269 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaBYTu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:50:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140224.191238.921310808350170272.davem@davemloft.net>
References: <1393266120.8041.19.camel@dcbw.local> <20140224.180426.411052665068255886.davem@davemloft.net>
 <1393286520.6823.123.camel@deadeye.wl.decadent.org.uk> <20140224.191238.921310808350170272.davem@davemloft.net>
From: Paul Marks <pmarks@google.com>
Date: Tue, 25 Feb 2014 11:50:38 -0800
Message-ID: <CAHaKRvKFwXSucvyrZVqxAZ8sa9tNBofPtJUK4hMRavTcZK9JZw@mail.gmail.com>
Subject: Re: [RFC v2 2/4] net: enables interface option to skip IP
To: David Miller <davem@davemloft.net>
Cc: ben@decadent.org.uk, dcbw@redhat.com, mcgrof@do-not-panic.com,
        zoltan.kiss@citrix.com, netdev@vger.kernel.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 4:12 PM, David Miller <davem@davemloft.net> wrote:
> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Tue, 25 Feb 2014 00:02:00 +0000
>
>> You can run an internal network, or access network, as v6-only with
>> NAT64 and DNS64 at the border.  I believe some mobile networks are doing
>> this; it was also done on the main FOSDEM wireless network this year.
>
> This seems to be bloating up the networking headers of the internal
> network, for what purpose?

The primary purpose of IPv6 is to bloat up network headers, because
the IPv4 headers were too small to address all the endpoints.

NAT64 is an intriguing solution to the problem of "I have too many
customers for 10.0.0.0/8".  Here's are some slides on the topic from
this week's APNIC conference:
https://conference.apnic.net/data/37/464xlat-apricot-2014_1393236641.pdf

A kernel with disable_ipv4 would be fairly usable on such a network
today, as long as you avoid AF_INET-specific apps.
