Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3ISJHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:07:55 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:56270 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044Ab3ISJHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:07:53 -0400
X-Greylist: delayed 739 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2013 05:07:53 EDT
X-RRZE-Submit-IP: 2001:638:a000:4142::ff10:e5e4
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: usbip-devel@lists.sourceforge.net,
        "Dominik Paulus" <dominik.paulus@fau.de>
Cc: linux-kernel@i4.cs.fau.de, "Tobias Polzer" <tobias.polzer@fau.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Stefan Reif" <ke42caxa@cip.cs.fau.de>,
        "Anthony Foiani" <anthony.foiani@gmail.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: Fix build on Debian ppc
References: <1379579978-2570-1-git-send-email-dominik.paulus@fau.de>
Date: Thu, 19 Sep 2013 10:55:18 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Tobias Polzer" <bulsa.t.polzer@studium.uni-erlangen.de>
Organization: FAU
Message-ID: <op.w3nhqgkq423x8j@localhost>
In-Reply-To: <1379579978-2570-1-git-send-email-dominik.paulus@fau.de>
User-Agent: Opera Mail/12.16 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When testing usbip under powerpc, it (unexpectedly) worked, but only after
removing the following lines from vhch_hcd.c:

1004         /* will be removed */
1005         if (pdev->dev.dma_mask) {
1006                 dev_info(&pdev->dev, "vhci_hcd DMA not supported\n");
1007                 return -EINVAL;
1008         }

We encountered no problems without those lines. Is it safe to remove this
check?

Regards,
           Tobias Polzer and Dominik Paulus
