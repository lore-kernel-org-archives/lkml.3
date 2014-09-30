Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaI3VDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:03:47 -0400
Received: from smtp-out-177.synserver.de ([212.40.185.177]:1049 "EHLO
	smtp-out-175.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751606AbaI3VDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:03:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29075
Message-ID: <542B1ABE.5000900@metafoo.de>
Date: Tue, 30 Sep 2014 23:03:58 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>, broonie@kernel.org,
        gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] regmap: Allow read_reg_mask to be 0
References: <1412093220-24690-1-git-send-email-dmurphy@ti.com>
In-Reply-To: <1412093220-24690-1-git-send-email-dmurphy@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 06:07 PM, Dan Murphy wrote:
> There may be spi devices that do not require a
> register read mask to read the registers.
>
> Currently the code sets the read mask based on
> a non-zero value passed in from the driver or if that
> value is 0 sets the read mask to 0x80.

It only sets it to the bus default if both read_flag_mask and 
write_flag_mask are 0. The assumption is that both of them being zero is a 
invalid configuration and either of them (or both) have to be non-zero for 
proper operation, since otherwise the device can't tell the difference 
between a read and a write.

Do you have a device where both the read and the write mask is 0?

- Lars
