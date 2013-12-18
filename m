Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab3LRFON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:14:13 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:59263 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3LRFOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:14:11 -0500
MIME-Version: 1.0
In-Reply-To: <41c1723da4454cdca6503418746a5ca7@DM2PR05MB671.namprd05.prod.outlook.com>
References: <52B0AEAD.6050604@gmail.com>
	<20131218010207.GC15119@google.com>
	<41c1723da4454cdca6503418746a5ca7@DM2PR05MB671.namprd05.prod.outlook.com>
Date: Tue, 17 Dec 2013 21:14:10 -0800
X-Google-Sender-Auth: DNvDmTZqKpk8S3yQwlOONLYefN0
Message-ID: <CAE9FiQVGQ8THfMBfEhaOnjbrdaRn+5CRoUoGZuVvRcZcAKqW_A@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently, during removal
From: Yinghai Lu <yinghai@kernel.org>
To: Rajat Jain <rajatjain@juniper.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatxjain@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 7:20 PM, Rajat Jain <rajatjain@juniper.net> wrote:
>
> Actually I did not understand the original problem and the solution in the first
> place (so I also do not understand how might disabling of presence detect notification
> help). If you can give more details on the original problem that shall be great. Here
> is what I understood from the commit log:
>
> The believe the HW looks like this:
>
> PCIe port <----> Repeater <----> Device.
>
> An in addition there is the presence detect pin that is connected directly from
> The port to the device. Now, when the device is plugged out, the pin indicates
> No presence. But are you saying the PCIe link from port to repeater is still up?

After the card is removed from the slot.

PCIe port try to retrain the link to repeater, like the link will keep
up and down.

so the presence bit will keep report one card present and not present.
that present bit should be OR of inband input and outband input.
We check the outband input and it always report correctly.

According to HW guys and Intel, that should be bug of repeater.

Disable the link from pcie to repeater, likely to reset the repeater....

Thanks

Yinghai
