Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaBYVGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:06:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaBYVGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:06:14 -0500
Message-ID: <1393362420.3032.8.camel@dcbw.local>
Subject: Re: [RFC v2 2/4] net: enables interface option to skip IP
From: Dan Williams <dcbw@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: mcgrof@do-not-panic.com, zoltan.kiss@citrix.com, netdev@vger.kernel.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Date: Tue, 25 Feb 2014 15:07:00 -0600
In-Reply-To: <20140224.180426.411052665068255886.davem@davemloft.net>
References: <1392857777.22693.14.camel@dcbw.local>
	 <CAB=NE6Xvqcdje5OSxjzTRa3wv-vZHr+MJHY86ZCfFXU2Lpzi8Q@mail.gmail.com>
	 <1393266120.8041.19.camel@dcbw.local>
	 <20140224.180426.411052665068255886.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 18:04 -0500, David Miller wrote:
> From: Dan Williams <dcbw@redhat.com>
> Date: Mon, 24 Feb 2014 12:22:00 -0600
> 
> > In the future I expect more people will want to disable IPv4 as
> > they move to IPv6.
> 
> I definitely don't.
> 
> I've been lightly following this conversation and I have to say
> a few things.
> 
> disable_ipv6 was added because people wanted to make sure their
> machines didn't generate any ipv6 traffic because "ipv6 is not
> mature", "we don't have our firewalls configured to handle that
> kind of traffic" etc.
> 
> None of these things apply to ipv4.
> 
> And if you think people will go to ipv6 only, you are dreaming.
> 
> Name a provider of a major web sitewho will go to strictly only
> providing an ipv6 facing site?
> 
> Only an idiot who wanted to lose significiant nunbers of page views
> and traffic would do that, so ipv4 based connectivity will be
> universally necessary forever.
> 
> I think disable_ipv4 is absolutely a non-starter.

Also, disable_ipv4 signals *intent*, which is distinct from current
state.

Does an interface without an IPv4 address mean that the user wished it
not to have one?

Or does it mean that DHCP hasn't started yet (but is supposed to), or
failed, or something hasn't gotten around to assigning an address yet?

disable_ipv4 lets you distinguish between these two cases, the same way
disable_ipv6 does.

Dan


