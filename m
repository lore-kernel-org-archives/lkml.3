Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaBSRCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:02:30 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:46286 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBSRC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:02:28 -0500
MIME-Version: 1.0
In-Reply-To: <5304C13F.3030802@citrix.com>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
 <1392433180-16052-2-git-send-email-mcgrof@do-not-panic.com>
 <20140216105754.63738163@nehalam.linuxnetplumber.net> <CAB=NE6WwbOXNLO_Mn42i7y62pEsmDOWd35B621eiJk4iaE3Hfg@mail.gmail.com>
 <1392803559.23084.99.camel@kazak.uk.xensource.com> <5304C13F.3030802@citrix.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 19 Feb 2014 09:02:06 -0800
X-Google-Sender-Auth: aQSII7wopRXhIVT9wQIeIUlVLbA
Message-ID: <CAB=NE6X6Vuo3iib0W-c5cxv0QBpnZtCC0sFyuULugQoEZAbRtg@mail.gmail.com>
Subject: Re: [Xen-devel] [RFC v2 1/4] bridge: enable interfaces to opt out
 from becoming the root bridge
To: Zoltan Kiss <zoltan.kiss@citrix.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 6:35 AM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
> On 19/02/14 09:52, Ian Campbell wrote:
>> Can't we arrange things in the Xen hotplug scripts such that if the
>> root_block stuff isn't available/doesn't work we fallback to the
>> existing fe:ff:ff:ff:ff usage?
>>
>> That would avoid concerns about forward/backwards compat I think. It
>> wouldn't solve the issue you are targeting on old systems, but it also
>> doesn't regress them any further.
>
> I agree, I think this problem could be better handled from userspace: if it
> can set root_block then change the default MAC to a random one, if it can't,
> then stay with the default one. Or if someone doesn't care about STP but DAD
> is still important, userspace can have a force_random_mac option somewhere
> to change to a random MAC regardless of root_block presence.

Folks, what if I repurpose my patch to use the IFF_BRIDGE_NON_ROOT (or
relabel to IFF_ROOT_BLOCK_DEF) flag for a default driver preference
upon initialization so that root block will be used once the device
gets added to a bridge. The purpose would be to avoid drivers from
using the high MAC address hack, streamline to use a random MAC
address thereby avoiding the possible duplicate address situation for
IPv6. In the STP use case for these interfaces we'd just require
userspace to unset the root block. I'd consider the STP use case the
most odd of all. The caveat to this approach is 3.8 would be needed
(or its the root block patches cherry picked) for base kernels older
than 3.8.

Stephen?

  Luis
