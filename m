Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaKFBG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:06:58 -0500
Received: from na6sys009bog030.obsmtp.com ([74.125.150.104]:33578 "HELO
	na6sys009bog030.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750883AbaKFBGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:06:55 -0500
Date: Wed, 5 Nov 2014 17:06:46 -0800
From: Joe Stringer <joestringer@nicira.com>
To: David Miller <davem@davemloft.net>
Cc: gerlitz.or@gmail.com, therbert@google.com, netdev@vger.kernel.org,
        sathya.perla@emulex.com, jeffrey.t.kirsher@intel.com,
        linux.nics@intel.com, amirv@mellanox.com, shahed.shaikh@qlogic.com,
        Dept-GELinuxNICDev@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/5] Implement ndo_gso_check() for vxlan nics
Message-ID: <20141106010501.GA18339@gmail.com>
Mail-Followup-To: Joe Stringer <joestringer@nicira.com>,
	David Miller <davem@davemloft.net>, gerlitz.or@gmail.com,
	therbert@google.com, netdev@vger.kernel.org,
	sathya.perla@emulex.com, jeffrey.t.kirsher@intel.com,
	linux.nics@intel.com, amirv@mellanox.com, shahed.shaikh@qlogic.com,
	Dept-GELinuxNICDev@qlogic.com, linux-kernel@vger.kernel.org
References: <CANr6G5xtNYenhd8KDWx+kRcnSZ0fahUdAL+6Wcz=5_dNvrQR6Q@mail.gmail.com>
 <CA+mtBx_BOmV+tOtio48M+xRatK79B31LoGnf4uvFJAbxYqOt_w@mail.gmail.com>
 <CAJ3xEMhxabp1EKbFPfvoZEFt=CQKFNcNrURGMX=7miDwmK9Y-A@mail.gmail.com>
 <20141105.163825.1433973842938441546.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105.163825.1433973842938441546.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:38:25PM -0500, David Miller wrote:
> From: Or Gerlitz <gerlitz.or@gmail.com>
> Date: Wed, 5 Nov 2014 23:32:44 +0200
> 
> > but fact is that the proposed patch series has the --same-- helper for
> > four drivers, so why not start with a that limited helper which would
> > be picked up by these drivers and we'll take it from there.
> 
> I'm in favor of the helper, duplication is error prone.
> 
> And in fact, any differences a driver ends up needing might be
> integratable into the helper.

My impression was that the changes are more likely to be
hardware-specific (like the i40e changes) rather than software-specific,
like changes that might be integrated into the helper.

That said, I can rework for one helper. The way I see it would be the
same code as these patches, as "vxlan_gso_check(struct sk_buff *)" in
drivers/net/vxlan.c which would be called from each driver. Is that what
you had in mind?
