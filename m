Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaJGMvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:51:17 -0400
Received: from mx.vmgattei.com ([77.223.18.35]:60093 "EHLO mx.vmgattei.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaJGMvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:51:16 -0400
Message-ID: <5433E1AB.7070204@sirius-es.it>
Date: Tue, 07 Oct 2014 14:50:51 +0200
From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: chris@printf.net, ulf.hansson@linaro.org
CC: shc_work@mail.ru, s.hauer@pengutronix.de, peter.griffin@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, agust@denx.de,
        gsi@denx.de, sbabic@denx.de
Subject: Re: [PATCH 0/2] mxcmmc driver fixes
References: <1412089178-21946-1-git-send-email-matteo.facchinetti@sirius-es.it>
In-Reply-To: <1412089178-21946-1-git-send-email-matteo.facchinetti@sirius-es.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone have any comments?


On 30/09/2014 16:59, Matteo Facchinetti wrote:
> From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
>
> Hi,
>
> this patchset contains fixes for the mxcmmc driver.
>
> *Patch 1:
> fix a rare race condition that breaks a data trasfer when mxcmmc
> driver use dma.
> To reproduce this error, use mmc as rootfs and start at boot time
> a realtime Xenomai application.
> The realtime it's not directly related but entropy produced by
> ipipe scheduler highlights the problem.
> When this event occurs, the mxcmmc watchdog expires,
> this cause a read error and application doesn't run.
>
> *Patch 2:
> fix the default value for available voltages into mxcmci_probe
>
> Applied to mainline Linux-3.17.0-rc6-next on arch mpc512x.
> Tested on mpc5125twr evaluation board
>
> Applied to custom Linux-3.9.4 on arch mpc512x
> Tested on a mpc5125 custom board.
>
> Regards,
> Matteo Facchinetti
> Sirius Electronic Systems
>
>
> Matteo Facchinetti (2):
>    mmc: mxcmmc: fix race condition when dma finish a data transfer
>    mmc: mxcmmc: fix the default value for available voltages into
>      mxcmci_probe
>
>   drivers/mmc/host/mxcmmc.c | 27 ++++++++++-----------------
>   1 file changed, 10 insertions(+), 17 deletions(-)
>

