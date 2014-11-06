Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaKFIXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:23:33 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:54818 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaKFIXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:23:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+mtBx-Js62X3BpfjQkcsh=w=-cgvSyM5ueCpufGVv0uu1nphw@mail.gmail.com>
References: <CAJ3xEMhxabp1EKbFPfvoZEFt=CQKFNcNrURGMX=7miDwmK9Y-A@mail.gmail.com>
	<20141105.163825.1433973842938441546.davem@davemloft.net>
	<20141106010501.GA18339@gmail.com>
	<20141105.211558.969082848816106943.davem@davemloft.net>
	<CA+mtBx-Js62X3BpfjQkcsh=w=-cgvSyM5ueCpufGVv0uu1nphw@mail.gmail.com>
Date: Thu, 6 Nov 2014 10:23:30 +0200
Message-ID: <CAJ3xEMi8bGS2ez0aLsyF0z1Ag18b8YtAH23uCdjHtP1Kxp-7hg@mail.gmail.com>
Subject: Re: [PATCH net 0/5] Implement ndo_gso_check() for vxlan nics
From: Or Gerlitz <gerlitz.or@gmail.com>
To: Tom Herbert <therbert@google.com>
Cc: David Miller <davem@davemloft.net>, Joe Stringer <joestringer@nicira.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Sathya Perla <sathya.perla@emulex.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "linux.nics" <linux.nics@intel.com>, Amir Vadai <amirv@mellanox.com>,
        "shahed.shaikh" <shahed.shaikh@qlogic.com>,
        dept-gelinuxnicdev <Dept-GELinuxNICDev@qlogic.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 4:44 AM, Tom Herbert <therbert@google.com> wrote:
> On Wed, Nov 5, 2014 at 6:15 PM, David Miller <davem@davemloft.net> wrote:
>> From: Joe Stringer <joestringer@nicira.com>
>> Date: Wed, 5 Nov 2014 17:06:46 -0800
>>
>>> My impression was that the changes are more likely to be
>>> hardware-specific (like the i40e changes) rather than software-specific,
>>> like changes that might be integrated into the helper.
>>
>> I think there is more commonality amongst hardware capabilities,
>> and this is why I want the helper to play itself out.
>>
>>> That said, I can rework for one helper. The way I see it would be the
>>> same code as these patches, as "vxlan_gso_check(struct sk_buff *)" in
>>> drivers/net/vxlan.c which would be called from each driver. Is that what
>>> you had in mind?
>>
>> Yes.
>
> Note that this code is not VXLAN specific, it will also accept NVGRE
> and GRE/UDP with keyid and TEB. I imagine all these cases should be
> indistinguishable to the hardware so they probably just work (which
> would be cool!). It might be better to name and locate the helper
> function to reflect that.

Unlike the VXLAN case, currently there's no indication from the
network stack towards the driver that an NVGRE tunnel was set, so in
our case we're not arming the HW offloads for NVGRE. I'll look into
that, maybe we can make them work always. Also re the math there to be
the same for VXLAN/NVGRE  -- skb_inner_mac_header(skb) -
skb_transport_header(skb) is exactly 8 (sizeof struct gre_base_hdr),
isn't that?
