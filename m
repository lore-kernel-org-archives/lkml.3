Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3AXQ5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:57:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37790 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3AXQ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:57:09 -0500
Message-ID: <510167DD.3090001@wwwdotorg.org>
Date: Thu, 24 Jan 2013 08:57:01 -0800
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: balbi@ti.com
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: host: tegra: make use of PHY pointer of HCD
References: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com> <20130124140504.GA2609@arwen.pp.htv.fi>
In-Reply-To: <20130124140504.GA2609@arwen.pp.htv.fi>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 06:05 AM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Jan 24, 2013 at 03:57:03PM +0530, Venu Byravarasu wrote:
>> As pointer to PHY structure can be stored in struct usb_hcd 
>> making use of it, to call Tegra PHY APIs.
>> 
>> Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(), so
>> that to avoid dereferencing of hcd after its freed up.
>> 
>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com> --- First
>> version of patch can be found at 
>> http://marc.info/?l=linux-kernel&m=135581479020213&w=2. As it was
>> not yet applied, sending v2 of the patch.
>> 
>> delta from v1: Modified all Tegra PHY APIs to use standard
>> 'structu usb_phy *' as their parameter instead of proprietary
>> parameter of type 'struct tegra_usb_phy *'.
> 
> I would like to see those tegra-specific functions vanish from the 
> driver. Can that be done for v3.10 merge window ?

Felipe, I assume that means you're OK with me taking this patch for
3.9 then?
