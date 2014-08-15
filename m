Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaHORcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:32:53 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44144 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHORcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:32:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACsCDONU9Zq902rj6aJXGZGnPfAWbxsiFe9mMS8usyyUdTYa9A@mail.gmail.com>
References: <20140723113314.GA7798@chaz.gmail.com>
	<53CFCD26.1020409@infradead.org>
	<CACsCDOP8DOnB0zZtT_WLhiBXjxXh1aH1eGF9_h0dRN1i9YDU-A@mail.gmail.com>
	<CAHA+R7MLQtYF5vBN0D66Wk8iyGZABf5=Az293gUH6w=4THv8Gw@mail.gmail.com>
	<CACsCDONU9Zq902rj6aJXGZGnPfAWbxsiFe9mMS8usyyUdTYa9A@mail.gmail.com>
Date: Fri, 15 Aug 2014 10:32:50 -0700
Message-ID: <CAHA+R7PpGqNYQcGZrsDB2kfmUM7HdXz2=t2PY8XeouF-PoGOFw@mail.gmail.com>
Subject: Re: network interfaces called "all", "default" or "config"
From: Cong Wang <cwang@twopensource.com>
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 1:33 AM, Stephane Chazelas
<stephane.chazelas@gmail.com> wrote:
> Yes, I know  those are also used for the eth0:1 "aliases", but the bug
> is, since it is allowed to do
>
>     ip link add link eth0 eth0:123 type vlan id 123
>
> Then the
>
>     ip link del link eth0 eth0:123
>
> should be allowed as well. Or probably better to avoid confusion
>
>     ip link add link eth0 foo:bar type vlan id 123
>
> should not be allowed.
>

Good point! I think the reason is that in the past we used ioctl()
to add or remove network interface so kernel just checks that
code path for name alias, so we probably need to check netlink
path as well since it makes really little sense that we allow create
names with a colon but disallow to delete them.

Stephen should know better than me.
