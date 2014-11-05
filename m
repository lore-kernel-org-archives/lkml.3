Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaKEMor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:44:47 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51439 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaKEMoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:44:46 -0500
MIME-Version: 1.0
In-Reply-To: <1415190872.2420.55.camel@jtkirshe-mobl>
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
	<1415138202-1197-4-git-send-email-joestringer@nicira.com>
	<1415190872.2420.55.camel@jtkirshe-mobl>
Date: Wed, 5 Nov 2014 14:44:45 +0200
Message-ID: <CAJ3xEMjaQ54yEUQGL-8VHoPm=4G5bhPaGBa55jypzfKviR4KyQ@mail.gmail.com>
Subject: Re: [linux-nics] [PATCH net 3/5] fm10k: Implement ndo_gso_check()
From: Or Gerlitz <gerlitz.or@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Joe Stringer <joestringer@nicira.com>,
        Linux Netdev List <netdev@vger.kernel.org>, linux.nics@intel.com,
        shahed.shaikh@qlogic.com, sathya.perla@emulex.com,
        Amir Vadai <amirv@mellanox.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dept-GELinuxNICDev@qlogic.com, Tom Herbert <therbert@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 2:34 PM, Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
> On Tue, 2014-11-04 at 13:56 -0800, Joe Stringer wrote:
>> ndo_gso_check() was recently introduced to allow NICs to report the
>> offloading support that they have on a per-skb basis. Add an
>> implementation for this driver which checks for something that looks
>> like VXLAN.
>>
>> Implementation shamelessly stolen from Tom Herbert:
>> http://thread.gmane.org/gmane.linux.network/332428/focus=333111
>>
>> Signed-off-by: Joe Stringer <joestringer@nicira.com>
>> ---
>> Should this driver report support for GSO on packets with tunnel
>> headers
>> up to 64B like the i40e driver does?
>> ---
>>  drivers/net/ethernet/intel/fm10k/fm10k_netdev.c |   12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>
> Thanks Joe, I will add your patch to my queue.

Hi Jeff, please see my comment on patch 0/5, we're essentially
replicating the same helper four different times (fm10k, mlx4, benet,
qlgc) - I don't see the point in doing so. I asked Joe to come up with
one generic helper and then to pick it up by the four drivers, makes
sense?
