Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaKEMiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:38:02 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34815 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaKEMiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:38:01 -0500
MIME-Version: 1.0
In-Reply-To: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
Date: Wed, 5 Nov 2014 14:38:00 +0200
Message-ID: <CAJ3xEMjkxRg=uM+0kjOM0Zh84XYm_O6PiWoeYSw=LirU=ZJ+rA@mail.gmail.com>
Subject: Re: [PATCH net 0/5] Implement ndo_gso_check() for vxlan nics
From: Or Gerlitz <gerlitz.or@gmail.com>
To: Joe Stringer <joestringer@nicira.com>
Cc: Linux Netdev List <netdev@vger.kernel.org>, sathya.perla@emulex.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux.nics@intel.com,
        Amir Vadai <amirv@mellanox.com>, shahed.shaikh@qlogic.com,
        Dept-GELinuxNICDev@qlogic.com, Tom Herbert <therbert@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 11:56 PM, Joe Stringer <joestringer@nicira.com> wrote:
> Most NICs that report NETIF_F_GSO_UDP_TUNNEL support VXLAN, and not other
> UDP-based encapsulation protocols where the format and size of the header may
> differ. This patch series implements ndo_gso_check() for these NICs,
> restricting the GSO handling to something that looks and smells like VXLAN.
>
> Implementation shamelessly stolen from Tom Herbert (with minor fixups):
> http://thread.gmane.org/gmane.linux.network/332428/focus=333111


Hi Joe,

1st, thanks for picking this task...2nd, for drivers that currently
support only pure VXLAN, I don't see the point
to replicate the helper suggested by Tom (good catch on the size check
to be 16 and not 12) four times and who know how more in the future.
Let's just have one generic helper and make the mlx4/be/fm10k/benet
drivers to have it as their ndo, OK?

Or.

>
> If there are particular differences for your driver on actual support, I'd like
> to hear about it. I adjusted the i40e driver to report support with tunnel
> headers of up to 64 octets, perhaps there are other specifics that I've missed.
>
> Joe Stringer (5):
>   be2net: Implement ndo_gso_check()
>   i40e: Implement ndo_gso_check()
>   fm10k: Implement ndo_gso_check()
>   net/mlx4_en: Implement ndo_gso_check()
>   qlcnic: Implement ndo_gso_check()
>
>  drivers/net/ethernet/emulex/benet/be_main.c      |   12 ++++++++++++
>  drivers/net/ethernet/intel/fm10k/fm10k_netdev.c  |   12 ++++++++++++
>  drivers/net/ethernet/intel/i40e/i40e_main.c      |   14 +++++++++++++-
>  drivers/net/ethernet/mellanox/mlx4/en_netdev.c   |   12 ++++++++++++
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |   12 ++++++++++++
>  5 files changed, 61 insertions(+), 1 deletion(-)
>
> --
> 1.7.10.4
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
