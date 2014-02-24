Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaBXSVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:21:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbaBXSVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:21:13 -0500
Message-ID: <1393266120.8041.19.camel@dcbw.local>
Subject: Re: [RFC v2 2/4] net: enables interface option to skip IP
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Date: Mon, 24 Feb 2014 12:22:00 -0600
In-Reply-To: <CAB=NE6Xvqcdje5OSxjzTRa3wv-vZHr+MJHY86ZCfFXU2Lpzi8Q@mail.gmail.com>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
	 <1392433180-16052-3-git-send-email-mcgrof@do-not-panic.com>
	 <1392668638.21106.5.camel@dcbw.local>
	 <CAB=NE6XGBp1RwO63W0ac6tTr9JcRM9TB9sap4pa+8PMWwjxu6g@mail.gmail.com>
	 <1392828325.21976.6.camel@dcbw.local>
	 <CAB=NE6VpUqwNNY4pgbS6du2VsZ6dH0TzQYXmiw6GGN-EiOsV6g@mail.gmail.com>
	 <1392857777.22693.14.camel@dcbw.local>
	 <CAB=NE6Xvqcdje5OSxjzTRa3wv-vZHr+MJHY86ZCfFXU2Lpzi8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 12:31 -0800, Luis R. Rodriguez wrote:
> On Wed, Feb 19, 2014 at 4:56 PM, Dan Williams <dcbw@redhat.com> wrote:
> > Note that there isn't yet a disable_ipv4 knob though, I was
> > perhaps-too-subtly trying to get you to send a patch for it, since I can
> > use it too :)
> 
> Sure, can you describe a little better the use case, as I could use
> that for the commit log. My only current use case was the xen-netback
> case but Zoltan has noted a few cases where an IPv4 or IPv6 address
> *could* be used on the backend interfaces (which I'll still poke as
> its unclear to me why they have 'em).

My use-case would simply be to have an analogue for the disable_ipv6
case.  In the future I expect more people will want to disable IPv4 as
they move to IPv6.  If you don't have something like disable_ipv4, then
there's no way to ensure that some random program or something doesn't
set up IPv4 stuff that you don't want.

Same thing for IPv6; some people really don't want IPv6 enabled on an
interface no matter what; they don't want an IPv6LL address assigned,
they don't want kernel SLAAC, they want to ensure that *nothing*
IPv6-related gets done for that interface.  The same can be true for
IPv4, but we don't have a way of doing that right now.

Dan

