Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3HTSS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:18:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41317 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750970Ab3HTSS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:18:58 -0400
Date: Tue, 20 Aug 2013 14:18:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Krzysztof Mazur <krzysiek@podlesie.net>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: Re: [PATCH 2/2] usb: fail on usb_hub_create_port_device() errors
In-Reply-To: <1377019476-7701-3-git-send-email-krzysiek@podlesie.net>
Message-ID: <Pine.LNX.4.44L0.1308201415020.1591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Krzysztof Mazur wrote:

> Ignoring usb_hub_create_port_device() errors cause later NULL pointer
> deference when uninitialized hub->ports[i] entries are dereferenced
> after port memory allocation error.
> 
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> ---
> I'm not sure if failing in that case is a good idea, but other solutions
> are more complex.
> 
> I tried also changing hdev->maxchild and skiping initialization
> of later ports, but it didn't work because in some cases
> hub->descriptor->bNbrPorts is used instead of hdev->maxchild.
> With simulated usb_hub_create_port_device() failure I have an Oops
> in hub_power_on().

I think this patch is correct.  However, we also should change the 
other places that refer to bNbrPorts; make them use maxchild instead.

> Another possible solution is allowing for uninitialized ports and
> checking for hub->ports[i] == NULL.

No, if we can't allocate memory for all the ports then the whole thing 
should fail.

Alan Stern

