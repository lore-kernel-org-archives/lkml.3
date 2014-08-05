Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaHEFiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 01:38:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:59039 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbaHEFiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 01:38:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,803,1400050800"; 
   d="scan'208";a="580094485"
Message-ID: <53E06DB9.2040904@linux.intel.com>
Date: Tue, 05 Aug 2014 13:38:01 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arend van Spriel <arend@broadcom.com>, brudley@broadcom.com,
        Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
        linville@tuxdriver.com, pieterpg@broadcom.com, dekim@broadcom.com,
        mcgrof@do-not-panic.com, antonio@open-mesh.com,
        johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: prevent watchdog from interfering with scanning
 and connecting
References: <539E8559.3010601@linux.intel.com> <539EA79C.7010206@broadcom.com> <53A30F96.3010206@linux.intel.com> <53A311E4.301@broadcom.com> <53CCC44C.2070507@linux.intel.com> <53D124B3.7030807@linux.intel.com> <53DFB6A1.7040900@linux.intel.com> <20140804165202.GG30282@n2100.arm.linux.org.uk>
In-Reply-To: <20140804165202.GG30282@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/8/5 0:52, Russell King - ARM Linux wrote:
> On Tue, Aug 05, 2014 at 12:36:49AM +0800, Fu, Zhonghui wrote:
>> Hi, Arend
>>
>> I investigated this issue, and its root cause is still that sdio
>> controller can't receive interrupts from WiFi chip on sdio bus when
>> sdio controller is in runtime suspend status. I am running 3.16-rc5
>> linux kernel on ASUS T100TA tablet, and using sdhci-acpi driver.
> That's the root cause.  I fixed this with the Freescale i.MX SD driver
> which is now able to report pending SDIO interrupts while runtime PM
> suspended.
>
> Other host drivers probably need fixing too, or having runtime PM
> disabled on them - if you can't receive SDIO interrupts while runtime
> PM suspended, then entering runtime PM while you have a SDIO device
> attached is a bug.
>
> This is something for the MMC people to deal with rather than Arend.
>
Yes, this should be sdhci-acpi bug, I will contact MMC people for this issue.


Thanks,
Zhonghui
