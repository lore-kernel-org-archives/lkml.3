Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaBSQqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:46:22 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:49004 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaBSQqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:46:17 -0500
MIME-Version: 1.0
In-Reply-To: <53024C58.4010900@citrix.com>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
 <1392433180-16052-2-git-send-email-mcgrof@do-not-panic.com> <53024C58.4010900@citrix.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 19 Feb 2014 08:45:55 -0800
X-Google-Sender-Auth: nVz7ZkgNI_FPFikfUmhYK_ZNeNk
Message-ID: <CAB=NE6XYjOd2vRpQCZOG-S5ZW4xjam+FOPAYzribNQpb50Q5pg@mail.gmail.com>
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

On Mon, Feb 17, 2014 at 9:52 AM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
> On 15/02/14 02:59, Luis R. Rodriguez wrote:
>>
>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>
>> It doesn't make sense for some interfaces to become a root bridge
>> at any point in time. One example is virtual backend interfaces
>> which rely on other entities on the bridge for actual physical
>> connectivity. They only provide virtual access.
>
> It is possible that a guest bridge together to VIF, either from the same
> Dom0 bridge or from different ones. In that case using STP on VIFs sound
> sensible to me.

You seem to describe a case whereby it can make sense for xen-netback
interfaces to end up becoming the root port of a bridge. Can you
elaborate a little more on that as it was unclear the use case.

Additionally if such cases exist then under the current upstream
implementation one would simply need to change the MAC address in
order to enable a vif to become the root port.  Stephen noted there is
a way to avoid nominating an interface for a root port through the
root block flag. We should use that instead of the MAC address hacks.
Let's keep in mind that part of the motivation for this series is to
avoid a duplicate IPv6 address left in place by use cases whereby the
MAC address of the backend vif was left static. The use case your are
explaining likely describes the more prevalent use case where address
conflicts can occur, perhaps when administrators for got to change the
backend MAC address. If we embrace a random MAC address we'd avoid
that issue, and but we'd need to update userspace to use the root
block on topologies where desired.

  Luis
