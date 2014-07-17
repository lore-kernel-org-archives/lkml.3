Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbaGQPGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:06:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54799 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933357AbaGQPGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:06:08 -0400
Date: Thu, 17 Jul 2014 11:06:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Gavin Guo <gavin.guo@canonical.com>
cc: sarah.a.sharp@linux.intel.com, <mathias.nyman@intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yk@canonical.com>, <anthony.wong@canonical.com>,
        <gerald.yang@canonical.com>
Subject: Re: [PATCH v2 1/1] usb: Check if port status is equal to RxDetect
In-Reply-To: <1405604056-18987-2-git-send-email-gavin.guo@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1407171059560.1517-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Gavin Guo wrote:

> When using USB 3.0 pen drive with the [AMD] FCH USB XHCI Controller
> [1022:7814], the second hotplugging will experience the USB 3.0 pen
> drive is recognized as high-speed device. After bisecting the kernel,
> I found the commit number 41e7e056cdc662f704fa9262e5c6e213b4ab45dd
> (USB: Allow USB 3.0 ports to be disabled.) causes the bug. After doing
> some experiments, the bug can be fixed by avoiding executing the function
> hub_usb3_port_disable(). Because the port status with [AMD] FCH USB
> XHCI Controlleris [1022:7814] is already in RxDetect
> (I tried printing out the port status before setting to Disabled state),
> it's reasonable to check the port status before really executing
> hub_usb3_port_disable().
> 
> Fixes: 41e7e056cdc6 (USB: Allow USB 3.0 ports to be disabled.)
> Signed-off-by: Gavin Guo <gavin.guo@canonical.com>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

I did not give you permission to add my Signed-off-by: line to this 
patch.  It wouldn't make any sense anyway, because I haven't merged the 
patch.

However, you can add

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

