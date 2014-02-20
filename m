Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaBTU3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:29:01 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:48026 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaBTU27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:28:59 -0500
MIME-Version: 1.0
In-Reply-To: <5306156B.4070105@citrix.com>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
 <1392433180-16052-2-git-send-email-mcgrof@do-not-panic.com>
 <53024C58.4010900@citrix.com> <CAB=NE6XYjOd2vRpQCZOG-S5ZW4xjam+FOPAYzribNQpb50Q5pg@mail.gmail.com>
 <5306156B.4070105@citrix.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 20 Feb 2014 12:28:37 -0800
X-Google-Sender-Auth: nfbVyPGq7YKnjaBDf_M-VjsdcnM
Message-ID: <CAB=NE6U7WsN80SOoDrDYvEj9tYYdmcLriCtS-tvLDVeqGmdfwA@mail.gmail.com>
Subject: Re: [Xen-devel] [RFC v2 1/4] bridge: enable interfaces to opt out
 from becoming the root bridge
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, kvm@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 6:47 AM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
> On 19/02/14 16:45, Luis R. Rodriguez wrote:
>
>> You seem to describe a case whereby it can make sense for xen-netback
>> interfaces to end up becoming the root port of a bridge. Can you
>> elaborate a little more on that as it was unclear the use case.
>
> Well, I might be wrong on that, but the scenario I was thinking: a guest
> (let's say domain 1) can have multiple interfaces on different Dom0 (or
> driver domain) bridges, let's say vif1.0 is plugged into xenbr0 and vif1.1
> is in xenbr1. If the guest wants to make a bridge of this two, then using
> STP makes sense.

The bridging would happen on the front end in that case no?

>  I wanted to bring up CloudStack's virtual router as an
> example, but then I realized it's probably doesn't do such thing. However I
> don't think we should hardcode that a netback interface can't be RP ever.

My patch did allow for this but the root block flag that Stephen
mentioned can always be lifted.

  Luis
