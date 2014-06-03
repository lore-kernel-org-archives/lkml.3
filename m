Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829AbaFCUaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:30:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39542 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541AbaFCUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:30:12 -0400
X-Sasl-enc: OI+mwxmLm3qJL3vEq9NRDbg3jGuu7XzjA4H5Kan+dGkJ 1401827411
Date: Tue, 3 Jun 2014 13:33:50 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 00/15] Thunderbolt driver for Apple MacBooks
Message-ID: <20140603203350.GC6582@kroah.com>
References: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 10:03:57PM +0200, Andreas Noever wrote:
> Hi,
> 
> Updated version of the driver. Includes changes by Matthew to make it work on
> Falcon Ridge hardware (present in the newest Mac(Book)Pro). 
> 
> Changes since v4 (suggested by Matthew):
>  - Changed the PCI quirks to check just for Apple hardware instead of checking
>    against a list of machines. (The PCI id check already restricts this quirk
> to the relevant Apple machines).
>  - Added Falcon Ridge PCI id to the driver and to the "wait_for_thunderbolt"
>    quirk (the "poweroff_thunderbolt" quirk is no longer necessary for Falcon
> Ridge devices).
>  - Fixed plug events for Falcon Ridge hardware.
> 
> @Matthew: I think that your patch was missing the Falcon Ridge PCI id within
> the wait_for_thunderbolt quirk (I have added it). If you have time could you
> verify that suspend/resume works on your MacPro?  Thanks!
> 
> As before Matthew's ACPI changes (latest version: [1]) are required for this to
> work properly. Without them you need to boot with a coldplugged TB device to
> prevent the firmware from disabling the controller.

Looks good, I'll queue these up to my tree after 3.16-rc1 is out unless
anyone finds any problems with them before then.

thanks,

greg k-h
