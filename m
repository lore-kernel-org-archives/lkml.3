Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab3DONkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:40:15 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51752 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3DONkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:40:13 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: HOWTO Undo/Revert of_platform_populate?
To: Rob Herring <robherring2@gmail.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <51392BD9.4010209@gmail.com>
References: <CAPybu_3LfWLYLSn52dgFDuBTASLvQ0_XWsywH=Avpma+4s921g@mail.gmail.com> <51392BD9.4010209@gmail.com>
Date: Mon, 15 Apr 2013 14:40:09 +0100
Message-Id: <20130415134009.0A70E3E0AA8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Mar 2013 18:07:53 -0600, Rob Herring <robherring2@gmail.com> wrote:
> On 03/07/2013 04:32 AM, Ricardo Ribalda Delgado wrote:
> > Hi
> > 
> > I have an FPGA attached to the pci bus. The FPGA has an internal bus
> > with multiple cores that are already supported in the kernel.
> > 
> > I have made a driver that populates those cores using a user provided
> > device tree. I use the function of_platform_populate for that.
> > 
> > All this is working fine, but now I need a method to undo what
> > of_platform_populate does when the fpga is reprogrammed.
> > 
> > I haven't found any function that does this in the api.
> > 
> > Before implementing my own I would like to know if am I missing something?
> 
> It's not possible in the current kernel. You need DT overlay support
> that was posted recently.

In the mean time you can merely recurse all the children of the parent
struct device, unregister them from the device model, and release them.

g.

