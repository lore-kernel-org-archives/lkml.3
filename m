Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaBRVnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:43:05 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54808 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaBRVnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:43:02 -0500
Date: Tue, 18 Feb 2014 13:42:57 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Dan Williams <dcbw@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC v2 2/4] net: enables interface option to skip IP
Message-ID: <20140218134257.667efe23@nehalam.linuxnetplumber.net>
In-Reply-To: <CAB=NE6XGBp1RwO63W0ac6tTr9JcRM9TB9sap4pa+8PMWwjxu6g@mail.gmail.com>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
	<1392433180-16052-3-git-send-email-mcgrof@do-not-panic.com>
	<1392668638.21106.5.camel@dcbw.local>
	<CAB=NE6XGBp1RwO63W0ac6tTr9JcRM9TB9sap4pa+8PMWwjxu6g@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014 13:19:15 -0800
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> Sure, but note that the both disable_ipv6 and accept_dada sysctl
> parameters are global. ipv4 and ipv6 interfaces are created upon
> NETDEVICE_REGISTER, which will get triggered when a driver calls
> register_netdev(). The goal of this patch was to enable an early
> optimization for drivers that have no need ever for ipv4 or ipv6
> interfaces.

The trick with ipv6 is to register the device, then have userspace
do the ipv6 sysctl before bringing the device up.
