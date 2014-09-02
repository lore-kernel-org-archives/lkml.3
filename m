Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaIBK1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:27:17 -0400
Received: from mxout5.netvision.net.il ([194.90.6.65]:40534 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaIBK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:27:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <54059AAD.2060905@gmail.com>
Date: Tue, 02 Sep 2014 13:23:41 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Arend van Spriel <arend@broadcom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, gregkh@linuxfoundation.org,
        arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: xillybus: Move out of staging
References: <1409471821-11809-1-git-send-email-eli.billauer@gmail.com>
 <20140901121318.GG5122@mwanda> <54046FDA.8060905@broadcom.com>
In-reply-to: <54046FDA.8060905@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arend.

On 01/09/14 16:08, Arend van Spriel wrote:
> Maybe it would be better to use the DMA-API instead of the PCI wrappers.

I just found out that the PCI wrappers were indeed removed from the 
DMA-API.txt documentation back in 2010, saying that "driver writers are 
always able to use the DMA API with any bus":

https://lkml.org/lkml/2010/3/8/470

On the other hand, I was under the impression that the PCI API is for 
(future?) platforms which may need a distinction between PCI and 
non-PCI. That is why the Xillybus driver does some acrobatics, so that 
the PCI API is used for PCI devices, and the general DMA API for non-PCI 
devices.

Given that the distinction is already there, is it wise to remove it, 
and use the plain DMA API for all? That will simplify the code, of 
course, but if there's any esoteric platform that needs a different 
treatment for PCI devices, it's better to stay as is, I suppose.

Thanks,
    Eli


