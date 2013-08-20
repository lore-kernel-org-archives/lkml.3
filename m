Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab3HTS7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:59:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46665 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751351Ab3HTS7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:59:19 -0400
Date: Tue, 20 Aug 2013 14:59:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Krzysztof Mazur <krzysiek@podlesie.net>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: Re: [PATCH 1/2] usb: fix cleanup after failure in hub_configure()
In-Reply-To: <20130820184236.GA782@shrek.podlesie.net>
Message-ID: <Pine.LNX.4.44L0.1308201457380.892-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Krzysztof Mazur wrote:

> > Why bother with a separate jump label?  Just set maxchild to 0 whenever 
> > a failure occurs.
> > 
> 
> Initially I had just straightforward "dev->maxchild = 0;" after fail,
> but I changed that to simplify the second patch and be able to
> use goto fail:
> 
> 	ret = usb_hub_create_port_device(hub, i + 1);
> 	if (ret < 0) {
> 		dev_err(hub->intfdev,
> 			"couldn't create port%d device.\n", i + 1);
> 		hdev->maxchild = i;
> 		goto fail;
> 	}
> 
> and avoid "return ret" here or something like
> 
> 	if (hdev->maxchild == hub->descriptor->bNbrPorts)
> 		hdev->maxchild = 0;
> 
> in the fail path.

The second patch can either clean up the port devices by hand, or else 
jump to a new label after the line that sets maxchild to 0.

Alan Stern

