Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847Ab3BYNZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 08:25:45 -0500
Received: from mx0.aculab.com ([213.249.233.131]:41870 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759828Ab3BYNZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 08:25:44 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Disable IPv4-mapped - enforce IPV6_V6ONLY
Date: Mon, 25 Feb 2013 13:23:04 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7168@saturn3.aculab.com>
In-Reply-To: <512B4EAF.2050301@linux-ipv6.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Disable IPv4-mapped - enforce IPV6_V6ONLY
Thread-Index: Ac4TTW+Ng8WtyTieQHqkJ/112Jzd8wADGz7A
References: <51278CF6.2060402@ahsoftware.de> <51292A2B.3000304@ahsoftware.de> <512B4EAF.2050301@linux-ipv6.org>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "YOSHIFUJI Hideaki" <yoshfuji@linux-ipv6.org>,
        "Alexander Holler" <holler@ahsoftware.de>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > A proper solution would be to either return false if net.ipv6.bindv6only is true and optval is false
> (which would break downward compatibility because it wouldn't just be a default and setsockopt might
> return an error) or to introduce a new sysctl variable like net.ipv6.bindv6only_enforced_silently.
> ("silently" because setsockopt() wouldn't return an error if net.ipv6.bindv6only is true and optval
> (v6only in the example above) is false.)
> >
> > I would volunteer to write a patch which introduces something like
> net.ipv6.bindv6only_enforced_silently if some maintainer would give me his ok.
> >
> > If so, the question remains if
> >
> > systemctl net.ipv6.bindv6only_enforced_silently = 1
> >
> > should set systemctl.net.ipv6.bindv6only too or if an error should be returned if
> net.ipv6.bindv6only is false.
> 
> I am not convinced why you need this, and I am not in favor of
> enfocing IPV6_V6ONLY, but... some points:
> 
> - We should allow system-admin to "enforce" IPV6_V6ONLY to 0 as well.
> - CAP_NET_ADMIN users should always be able to use both modes
>   (They can do sysctl anyway.)
> - setsockopt should fail w/ EPERM if user tries to override.

I can imagine that some programs will always try to clear IPV6_V6ONLY
(maybe for portability with other OS which default to setting it
for security reasons) and will error-exit if it fails.
So non-silent enforcing could be a PITA.

OTOH there might be programs/systems where silent failure is wrong.

You really don't want to (globally) stop an application setting
IPV6_V6ONLY, such a program may well be creating separate IPv4
and IPv6 sockets.

Some of this needs to be part of some application wide 'security'
framework - that probably doesn't exist!

Should there also be similar controls for the use of IPv4
mapped addresses in actual on-the-wire IPv6 packets - eg those
destined for a remote gateway on an IPv6 only system?

	David



