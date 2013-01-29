Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3A2Q2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:28:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab3A2Q1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:27:43 -0500
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Tue, 29 Jan 2013 16:27:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        Vineet.Gupta1@synopsys.com
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
In-Reply-To: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301291627.34913.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:s5PKj2C/NRmcD1zs54rIlzQKNoquPo42O+/2yA8OouI
 7HP0t+J/+qN3fkumUQYyuDpWoV7PRUXl2jLEYsuHGaz+jbKJ8q
 P7N+PQJmUwYRUy0khZphGiF6FXWJPnEI8RHGYrA7SVBbxzy5MZ
 fouifjV0tKjscDqzsMYuFVfPIB4YF4qbKICJFUskM0S0iUTH15
 VbjgMbXPrA2zJbheAzsPKqm9xyoxSysbTvrPkFXqewi4zJQEYQ
 sbHv/SdmXA2/0GY3LJ91xav/BHLOH6TEQsJraydzF66hSUWRzT
 xA/pVN9ptu62Kxs3Wg3v319geRtTXZ5Hg0d7XATvWouatoyBj3
 9ArnTOmIxenttbvj1hR/7/2hO79E+tHHjd3Spst2N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2013, Alexey Brodkin wrote:
> in(out)_8/in(out)_be16/in(out)_le16 are very powerpc/microblaze
> specific. To enable use of Xilinx System ACE driver build for other
> architectures (for example it's possible to use it on Xilinx ml-509
> board with ARC700 in FPGA) we need to use generic implementation of
> accessors.
> 
> Current implementation was successfully built with Sourcery G++ Lite
> 2011.03-39 for Power EABI (ppc44x_defconfig).
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

Is this driver used on powerpc64 as well, or just on microblaze
and/or 32 bit powerpc?

On 64 bit powerpc, ioread involves extra overhead because it
goes through the PCI error handling implementation, so we should
keep using in_le() there.	

	Arnd
