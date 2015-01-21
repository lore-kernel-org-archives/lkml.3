Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbbAUQCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:02:50 -0500
Received: from smtp-out-054.synserver.de ([212.40.185.54]:1044 "EHLO
	smtp-out-053.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754163AbbAUQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:02:43 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20431
Message-ID: <54BFCDA1.4060205@metafoo.de>
Date: Wed, 21 Jan 2015 17:02:41 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?windows-1252?Q?S=F6ren_Brink?= =?windows-1252?Q?mann?= 
	<soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] spi/xilinx: Use automatic bus number on device tree
References: <1421855590-9210-1-git-send-email-ricardo.ribalda@gmail.com> <1421855590-9210-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1421855590-9210-2-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 04:53 PM, Ricardo Ribalda Delgado wrote:
> If there is more than one spi device on a device tree, the second one
> will fail to probe due to a duplicated bus_num.
 > [...]

This should already be fixed. See commit 4b153a2137c5 ("spi: xilinx: Use 
pdev->id instead of pdev->dev.id for the SPI bus number")[1]. If the device 
was registered using devicetree pdev->id is -1, so dynamic numbers will be used.

- Lars

[1] 
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/spi/spi-xilinx.c?id=4b153a2137c5d2914794c8944d78c731c1b0ae9d

