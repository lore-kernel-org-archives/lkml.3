Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbaLJSrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:47:40 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34077 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbaLJSri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:47:38 -0500
MIME-Version: 1.0
In-Reply-To: <54887901.8070501@broadcom.com>
References: <1418169871-19232-3-git-send-email-rjui@broadcom.com>
 <9707535.Y78sV0TgX4@wuerfel> <54887901.8070501@broadcom.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 10 Dec 2014 10:46:57 -0800
Message-ID: <CAGVrzcbZ_f43Vf1mu2XErVi_Jehjggh2TREyrSs84ntSm98yvg@mail.gmail.com>
Subject: Re: [PATCH 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
To: Scott Branden <sbranden@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ray Jui <rjui@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-10 8:46 GMT-08:00 Scott Branden <sbranden@broadcom.com>:
> On 14-12-10 03:31 AM, Arnd Bergmann wrote:
>>
>> On Tuesday 09 December 2014 16:04:29 Ray Jui wrote:
>>>
>>> Add initial version of the Broadcom iProc PCIe driver. This driver
>>> has been tested on NSP and Cygnus and is expected to work on all iProc
>>> family of SoCs that deploys the same PCIe host controller
>>>
>>> The driver also supports MSI
>>>
>>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>>
>>
>> The driver looks suspiciously like the one that Hauke already submitted a
>> while ago for bcm53xx. Please come up with a merged driver that works for
>> both.
>
> Could you please be a little more specific.  What driver did "Hauke already
> submitted"?  I do not see any driver in the kernel you are talking about.

https://www.marc.info/?l=linux-pci&m=141547043110684&w=2

>>
>>
>> Are you sure that iProc isn't based on the BCMA bus infrastructure after
>> all? Even the physical address of your PCI host falls into the address
>> range that is used for the internal BCMA bus on the other chips!
>
> BCMA seems to be for MIPS architectures.  It seems to be quite specific to
> those architectures using BCMA.  I see no use of it in bcm53xx code?

BCMA lives in its own directory in drivers/bcma/ and is not specific
to MIPS actually. Older BCM47xx/BCM53xx MIPS-based SoCs traditionally
started with a discoverable Silicon Sonics Backplane (drivers/ssb) and
progressively migrated to BCMA (drivers/bcma), both subsystems offer a
very similar bus/device/driver abstraction and discovery mechanism.
-- 
Florian
