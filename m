Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaBYPoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:44:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:65011 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaBYPoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:44:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: DMABOUNCE in pci-rcar
Date: Tue, 25 Feb 2014 16:44:01 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Magnus Damm <damm@opensource.se>, linux-pci@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "SH-Linux" <linux-sh@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <201402241200.21944.arnd@arndb.de> <20140225001748.GS21483@n2100.arm.linux.org.uk> <CANqRtoSsra-NQF_4dz1iBjzEvdaUco9o3gbPi_6rEgswV=maCw@mail.gmail.com>
In-Reply-To: <CANqRtoSsra-NQF_4dz1iBjzEvdaUco9o3gbPi_6rEgswV=maCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402251644.01463.arnd@arndb.de>
X-Provags-ID: V02:K0:jQ5OrY3A+hH/XirAy57ZUWHO4uqdOFPljw+oMOZkGPY
 nwS0Ep4MJfCQal37g6r37Sh8WwAnfzZTW1Xw8NsENMr0qpEowV
 xOaQFB5aBj3dN4taTWfPzair+zg21Hlts33ZHrlOff+SQCKaRN
 FKg+P26zb0FEIZnofQWA8jY3Gvg/EhEx/bSCe2ERaOH0OK+Wuu
 ijODJXJ6tp9mCOPunt0Z0uV1QdXQEJCABzECWnD24sT0OmL/BM
 +h8W6smkAU4LsZ83B28axjnfdR2HiUiB4U740jDeOYEeq7ZMSZ
 2V+fOXO8VEhA5Yz5y5apzmCsLrSNKa7GscBIzotmO0r2TY4YJ8
 pZfTzE48Piavcm35vG7c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 February 2014, Magnus Damm wrote:
> And the DMABOUNCE code does not support HIGHMEM, so because of that
> the block layer BOUNCE is also used.

Ah, I misunderstood this part previously. I understand better what's
going on now, but this also enforces the impression that both BOUNCE
and DMABOUNCE are not what you should be doing here.

On a related note, I've had some more discussions with Santosh on IRC,
and I think he's in the exact same position on mach-keystone, so we
should make sure that whatever solution either of you comes up with
also works for the other one.

The situation on keystone may be a little worse even, because all their
DMA masters have a 2GB limit, but it's also possible that the same
is true for you. Which categories of DMA masters do you have on R-Car?

a) less than 32-bit mask, with IOMMU
b) less than 32-bit mask, without IOMMU
c) 32-bit mask
d) 64-bit mask

	Arnd
