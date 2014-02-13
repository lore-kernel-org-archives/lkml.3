Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaBMLBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:01:23 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55255 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaBMLBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:01:21 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ff-52fca5ffea70
Message-id: <52FCA5FC.80504@samsung.com>
Date: Thu, 13 Feb 2014 12:01:16 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH v2 4/6] ARM: firmware: add prepare_idle() operation
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
 <1391747706-1847-5-git-send-email-acourbot@nvidia.com>
In-reply-to: <1391747706-1847-5-git-send-email-acourbot@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xa7r/l/4JMpi/WMri+8NTrBbnXj1i
	sdj0+BqrxeVdc9gsOr/MYrO4fZnX4tT1z2wWrw62sVj83DWPxYHTo6W5h81j56y77B6bl9R7
	XDnRxOrR2/yOzePzJjmPjXNDA9ijuGxSUnMyy1KL9O0SuDJ657axFlxirXj44h5jA+Mhli5G
	Tg4JAROJU6uPMELYYhIX7q1n62Lk4hASWMoocfTvXlYI5zOjxKHWHcwgVbwCGhLfl94F62YR
	UJWY2veTFcRmE1CT+NzwiA3EFhWIkPg7bz0jRL2gxI/J98DqRQRWM0p8fh8GMpRZYAajROev
	Q0wgCWEBd4mFPX/BGoQEqiV2PuoEG8op4CxxcFsTWA2zgLXEyknbGCFseYnNa94yT2AUmIVk
	xywkZbOQlC1gZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERILX3YwLj5mdYhRgINRiYfX
	YtnvICHWxLLiytxDjBIczEoivDISf4KEeFMSK6tSi/Lji0pzUosPMTJxcEo1MK5jMwtIipOL
	Nr4y/U3XNk8O//4HPyfncT/QcpC+L2HRsV14T2p/WciJw0fN4zZ/2f3IQFxm5cRLe3aWH12y
	3OjcoV2nPzNs/3Ba1GT2qcNT/wT5ZRbaSjQfer/W0INJM587w7/547ngutrU+W+0ypUXNLxJ
	zEpZpXc3dcKvzXPnLJFgNRT/d1mJpTgj0VCLuag4EQC3WPUMYwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On 07.02.2014 05:35, Alexandre Courbot wrote:
> Some firmwares do not put the CPU into idle mode themselves, but still
> need to be informed that the CPU is about to enter idle mode before this
> happens. Add a prepare_idle() operation to the firmware_ops structure to
> handle such cases.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>   arch/arm/include/asm/firmware.h | 4 ++++
>   1 file changed, 4 insertions(+)

I wonder if .do_idle() couldn't simply return an appropriate error code 
to let the upper layer know that it should proceed with normal CPU idle 
activation, while still letting the firmware know that the CPU is going 
to idle.

Best regards,
Tomasz
