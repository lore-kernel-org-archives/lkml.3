Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab3BYIid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 03:38:33 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:42009 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3BYIib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 03:38:31 -0500
MIME-Version: 1.0
In-Reply-To: <5127C716.6050903@linux-ipv6.be>
References: <1354533387-4110-1-git-send-email-acooks@gmail.com>
	<1355914703-28576-1-git-send-email-acooks@gmail.com>
	<5127C716.6050903@linux-ipv6.be>
Date: Mon, 25 Feb 2013 16:37:08 +0800
Message-ID: <CAJtEV7avQcDokktNdziQ+8j+37q7PSbZstxQ09xNWq-6XfAFbw@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix Intel IOMMU support for Marvell 88SE91xx SATA controllers.
From: Andrew Cooks <acooks@gmail.com>
To: Stijn Tintel <stijn@linux-ipv6.be>
Cc: "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>, YingChu <xjtuychu@hotmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        David Woodhouse <dwmw2@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 3:29 AM, Stijn Tintel <stijn@linux-ipv6.be> wrote:
> On 19-12-12 11:58, Andrew Cooks wrote:
>> This is my second attempt to make Marvell 88SE91xx SATA controllers work when IOMMU is enabled.[1][2]
>> As suggested, it no longer tries to add support for phantom functions.
>>
>> What's missing:
>> * No AMD support. I need some help with this.
>> * Table of affected chip IDs is incomplete. I think 0x9123, 0x9125, 0x9128 are also affected.
> This one is also affected: 08:00.0 0106: 1b4b:9130 (rev 11), this is in
> dmesg:
>
> [    1.914086] dmar: DMAR:[DMA Read] Request device [08:00.1] fault addr
> fff00000

Handling specific chip revisions is another issue I'm not sure how to
handle. We could use another bitmap field, but we need more vendor
cooperation to know exactly which chip model and revision combinations
are affected.

>>
>> Patch is against 3.7.1
>>
>> Review and feedback would be appreciated.
> I changed your patch to check for my chip ID, and it solves my problem:
> no more hang during boot, and the HDD connected to this controller is
> now detected with IOMMU enabled.
>
> Also see 1 minor comment inline.

Thanks for the feedback!  I'll include your PCI_VENDOR_ID change in
the next iteration of the patch.
