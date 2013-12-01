Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab3LAUjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 15:39:40 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1633 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab3LAUji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 15:39:38 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Subject: Re: [PATCH] PCI / tg3: Give up chip reset and carrier loss
 handling if PCI device is not present
From: "Michael Chan" <mchan@broadcom.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Linux PM list" <linux-pm@vger.kernel.org>,
        "Linux PCI" <linux-pci@vger.kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "Nithin Nayak Sujir" <nsujir@broadcom.com>,
        "David Miller" <davem@davemloft.net>
In-Reply-To: <7807315.7cU9KldDtM@vostro.rjw.lan>
References: <7807315.7cU9KldDtM@vostro.rjw.lan>
Date: Sun, 1 Dec 2013 12:39:19 -0800
Message-ID: <1385930359.6988.7.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E8541EC15012783306-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-01 at 02:34 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Modify tg3_chip_reset() and tg3_close() to check if the PCI network
> adapter device is accessible at all in order to skip poking it or
> trying to handle a carrier loss in vain when that's not the case.
> Introduce a special PCI helper function pci_device_is_present()
> for this purpose.
> 
> Of course, this uncovers the lack of the appropriate RTNL locking
> in tg3_suspend() and tg3_resume(), so add that locking in there
> too.
> 
> These changes prevent tg3 from burning a CPU at 100% load level for
> solid several seconds after the Thunderbolt link is disconnected from
> a Matrox DS1 docking station. 

I'm not familiar with the DS1.  Does the tg3 device get removed through
tg3_remove_one() in this case?  What happens when you reconnect the DS1?


