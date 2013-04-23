Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3DWGXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:23:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17111 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab3DWGXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:23:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 22 Apr 2013 23:20:59 -0700
Message-ID: <517627CB.1000504@nvidia.com>
Date: Tue, 23 Apr 2013 11:48:51 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps62360: Fix off-by-one shift for ramp_ctrl
References: <1366691753.25625.6.camel@phoenix>
In-Reply-To: <1366691753.25625.6.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013 10:05 AM, Axel Lin wrote:
> According to the datasheet[1]
>
> Register 0x06h Description: RmpCtrl (REGISTER ADDRESS: 0x06h Read/Write)
> BIT[5..7]:
>          RMP[2:0] Output voltage ramp timing
>          D7-D5   Slope
>          000     32mV/us
>          001     16mV/us
>          010     8mV/us
>          ...
>          110     0.5mV/us
>          111     0.25mV/us
>
> Thus to get correct ramp_ctrl value, we need to right-shift 5 bits.
>
> [1] http://www.ti.com/lit/ds/symlink/tps62360.pdf
>

Checked with my latest and it is correct.
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
