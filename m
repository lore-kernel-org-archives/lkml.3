Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3GYNVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:21:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab3GYNVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:21:50 -0400
Message-ID: <51F12668.8000400@suse.cz>
Date: Thu, 25 Jul 2013 15:21:44 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Frank Haverkamp <haver@vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        jsvogt@de.ibm.com, MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com,
        michael@ibmra.de
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver
References: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com> <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
In-Reply-To: <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.7.2013 10:28, Frank Haverkamp wrote:
> +	dev_info(&pci_dev->dev, "GenWQE driver version: %s (build %s) %s%u\n",
> +		 DRV_VERS_STRING, __DATE__, GENWQE_DEVNAME, cd->card_idx);
[...]
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "GenWQE driver version: %s (build %s)\n"
> +			 "    Device Name/Type: %s %s CardIdx: %d\n"
> +			 "    SLU/APP Config  : 0x%016llx/0x%016llx\n"
> +			 "    Build Date/Type : %u/%x/%u %s\n"
> +			 "    Base Clock      : %u MHz\n"
> +			 "    Arch/SVN Release: %u/%llx\n"
> +			 "    Bitstream       : %llx\n",
> +			 DRV_VERS_STRING, __DATE__, dev_name(&pci_dev->dev),

Please remove the __DATE__ macros, so that the generated object code
does not literally change with the phase of the moon.

Michal

