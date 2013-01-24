Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3AXP7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:59:03 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:44040 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3AXP67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:58:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130124140504.GA2609@arwen.pp.htv.fi>
References: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com> <20130124140504.GA2609@arwen.pp.htv.fi>
From: BVG Rao <venubyravarasu@gmail.com>
Date: Thu, 24 Jan 2013 21:28:32 +0530
Message-ID: <CAH7OJZsL2akgaU5qQo=gykVAcFkYyCbP4f1WuBDePd5o788o4A@mail.gmail.com>
Subject: Re: [PATCH v2] usb: host: tegra: make use of PHY pointer of HCD
To: balbi@ti.com
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, swarren@wwwdotorg.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 7:35 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Thu, Jan 24, 2013 at 03:57:03PM +0530, Venu Byravarasu wrote:
>> As pointer to PHY structure can be stored in struct usb_hcd
>> making use of it, to call Tegra PHY APIs.
>>
>> Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(),
>> so that to avoid dereferencing of hcd after its freed up.
>>
>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
>> ---
>> First version of patch can be found at
>> http://marc.info/?l=linux-kernel&m=135581479020213&w=2. As it was not
>> yet applied, sending v2 of the patch.
>>
>> delta from v1:
>> Modified all Tegra PHY APIs to use standard 'structu usb_phy *' as
>> their parameter instead of proprietary parameter of type 'struct tegra_usb_phy *'.
>
> I would like to see those tegra-specific functions vanish from the
> driver. Can that be done for v3.10 merge window ?

Deleting these functions may not be possible because of the way,
Tegra20 USB PHY and controllers are designed.
Hence I'm trying to remove tegra specific structure pointers as
function parameter
and use generic USB PHY structure pointers instead.

>
> --
> balbi
