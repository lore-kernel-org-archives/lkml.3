Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaLHOne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:43:34 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54075 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHOnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:43:33 -0500
Date: Mon, 8 Dec 2014 14:43:28 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Christophe Kerello <christophe.kerello@st.com>,
        computersforpeace@gmail.com, kernel@stlinux.com
Subject: Re: [STLinux Kernel] [PATCH v2 RESEND 10/11] mtd: st_spi_fsm:
 Provide mask to obtain correct boot device pins
Message-ID: <20141208144328.GA1104@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
 <1417688512-7644-11-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417688512-7644-11-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Thu, 04 Dec 2014, Lee Jones wrote:

> From: Christophe Kerello <christophe.kerello@st.com>
> 
> This patch adds a mask to be able to get the right boot device selection.

Have you seen this series I posted https://lkml.org/lkml/2014/11/19/71?

It is trying to consolodate the way the various STI drivers are handling syscfg
registers in the upstream kernel. Now this series came about mainly due to the mixing of address
spaces in the reg property, but the overall aim was to get all STI drivers handling
syscfg registers in a uniform way.

Sadly it seems this driver uses another approach for syscfg handling with extra
DT properties encoding the offset and mask.

IMHO I don't think it makes sense to add more DT properties for doing this. We should consider
migrating this over to using the interface provided in the series above, and for the mask I
would suggest implementing it in a similar way to the code in drivers/phy/phy-stih41x-usb.c 
which solves much the same problem by statically encoding the information in the driver
and making a decision based on the compatible flag.

regards,

Peter.
