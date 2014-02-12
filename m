Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaBLTwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:52:23 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:58106 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaBLTwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140212121739.ecb2f222.billfink@mindspring.com>
References: <1392071391-13215-1-git-send-email-mcgrof@do-not-panic.com>
 <1392071391-13215-3-git-send-email-mcgrof@do-not-panic.com>
 <1392108205.22033.16.camel@dagon.hellion.org.uk> <CAB=NE6Vu=khpj_3J7r-u8DFkhyC-RgLikNFtOU-WO7te_4HMCw@mail.gmail.com>
 <1392203708.13563.50.camel@kazak.uk.xensource.com> <20140212121739.ecb2f222.billfink@mindspring.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 12 Feb 2014 11:52:00 -0800
X-Google-Sender-Auth: -q6l4rnJF3DyZuIeADJW9LyzWog
Message-ID: <CAB=NE6Wfy-+Z4-NksF9qspz3+6Cq9JNYFvzQ9i1=YoCe0KWpbQ@mail.gmail.com>
Subject: Re: [RFC 2/2] xen-netback: disable multicast and use a random hw MAC address
To: Bill Fink <billfink@mindspring.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xen-devel@lists.xenproject.org, Paul Durrant <Paul.Durrant@citrix.com>,
        Wei Liu <wei.liu2@citrix.com>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 9:17 AM, Bill Fink <billfink@mindspring.com> wrote:
> On Wed, 12 Feb 2014, Ian Campbell wrote:
>> IOW -- enabling/disabling multicast seems to me to be an odd proxy for
>> disabling SLAAC or DAD and AIUI your patch fixes the opposite case,
>> which is to avoid SLAAC and DAD on interfaces which don't do multicast
>> (which makes sense since those protocols involve multicast).
>
> Forgive me if this doesn't make sense in this context since
> I'm not a kernel developer, but I was just wondering if any of
> the sysctls:
>
>         /proc/sys/net/ipv6/conf/<ifc>/disable_ipv6
>         /proc/sys/net/ipv6/conf/<ifc>/accept_dad
>         /proc/sys/net/ipv6/conf/<ifc>/accept_ra
>         /proc/sys/net/ipv6/conf/<ifc>/autoconf
>
> would be apropos for the requirement being discussed.

These are run time configuration options, post initialization. What
we're considering is internal net_device capability fields, to even
avoid creating these in the first place.

  Luis
