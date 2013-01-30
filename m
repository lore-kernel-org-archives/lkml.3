Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3A3M3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:29:40 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:50758 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3A3M3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:29:38 -0500
Message-ID: <5109121F.1000205@mvista.com>
Date: Wed, 30 Jan 2013 16:29:19 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Youquan Song <youquan.song@intel.com>
CC: htejun@gmail.com, ming.lei@canonical.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, seth.heasley@intel.com, jlee@suse.com,
        james.d.ralston@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] ata: Fix DVD not dectected at some Haswell platforms
References: <1359566374-27286-1-git-send-email-youquan.song@intel.com>
In-Reply-To: <1359566374-27286-1-git-send-email-youquan.song@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 30-01-2013 21:19, Youquan Song wrote:

> There is a quirk patch 5e5a4f5d5a08c9c504fe956391ac3dae2c66556d fix the 4 ports
> IDE controller 32bit PIO mode.
> Recently, the problem was showed at Haswell platform which includes 2 ports
> IDE controller.

> So introduce a qurik patch to disable 32bit PIO at this IDE controller.

> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
>   drivers/ata/ata_piix.c |   14 +++++++++++++-
>   1 files changed, 13 insertions(+), 1 deletions(-)

> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index ef773e1..1993e52 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
[...]
> @@ -326,7 +327,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
>   	/* SATA Controller IDE (Lynx Point) */
>   	{ 0x8086, 0x8c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
>   	/* SATA Controller IDE (Lynx Point) */
> -	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
> +	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
>   	/* SATA Controller IDE (Lynx Point) */
>   	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },

    Also, are you sure this one and the following Lynx Point controllers are 
not affected?

>   	/* SATA Controller IDE (Lynx Point-LP) */

MBR, Sergei

