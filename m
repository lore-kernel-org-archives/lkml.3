Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaIEG6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:58:35 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:41178 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaIEG6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:58:33 -0400
Message-ID: <54095F65.6010405@gmail.com>
Date: Fri, 05 Sep 2014 12:59:49 +0600
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, falcon@meizu.com, tiwai@suse.de,
        tj@kernel.org, arjan@linux.intel.com
CC: linux-kernel@vger.kernel.org, oleg@redhat.com, hare@suse.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de, santosh@chelsio.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>, linux-ide@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [RFC v2 6/6] pata_marvell: use async probe
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com> <1409899047-13045-7-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1409899047-13045-7-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.09.2014 12:37, Luis R. Rodriguez пишет:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> Alexander reported that on his Sony VAIO VPCZ23A4R laptop
> experiences long delays on boot when connected to its dock
> station on pre 3.9 kernels but anything after 3.9 will cause
> the device to not be detected at all ending with:
>
> [   38.065673] pata_marvell 0000:1a:00.0: no available native port
> [   38.065769] pata_acpi 0000:1a:00.0: no available native port

I object to this commit message, it is based on outdated information and 
is due to a different bug that was fixed in 3.10 as a last-minute fix. 
Modern kernels just experience long delays during boot.

> This laptop has a Marvell 88SE6121 SATA II Controller [11ab:6121]
> and a BluRay writer attached. The reason for the delays are
> caused by SRST errors and the link being slow to respond.
> The pata_marvell driver is a simple libata wrapper so the
> real required changes need to be made on libata however not
> many folks are around and available anymore with intimate
> knowledge and experience with these devices. Alexander notes
> that it may be that *any* ATA BMDMA controller that fails to
> respond to an identify command until a reset or other device
> poking might suffer from similar fate, this needs to be
> investigated further. Using async probe the issue caused
> by systemd killing the driver after taking over 30 seconds
> on probe.
>
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=59581
>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Benjamin Poirier <bpoirier@suse.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: patrakov@gmail.com
> Reported-by: "Alexander E. Patrakov" <patrakov@gmail.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>   drivers/ata/pata_marvell.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
> index ae9feb1..6a543b9 100644
> --- a/drivers/ata/pata_marvell.c
> +++ b/drivers/ata/pata_marvell.c
> @@ -175,6 +175,7 @@ static struct pci_driver marvell_pci_driver = {
>   	.suspend		= ata_pci_device_suspend,
>   	.resume			= ata_pci_device_resume,
>   #endif
> +	.driver.async_probe = true,
>   };
>
>   module_pci_driver(marvell_pci_driver);
>


-- 
Alexander E. Patrakov
