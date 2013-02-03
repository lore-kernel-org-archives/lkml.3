Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3BCLSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:18:48 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35776 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3BCLSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:18:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2013 12:18:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 13/62] firewire: convert to idr_alloc()
Message-ID: <20130203121809.2fb21a0c@stein>
In-Reply-To: <20130203120344.2e31b500@stein>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	<1359854463-2538-14-git-send-email-tj@kernel.org>
	<20130203120344.2e31b500@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 03 Stefan Richter wrote:
> On Feb 02 Tejun Heo wrote:
> > --- a/drivers/firewire/core-device.c
> > +++ b/drivers/firewire/core-device.c
> > @@ -1017,13 +1017,12 @@ static void fw_device_init(struct work_struct *work)
> >  
> >  	fw_device_get(device);
> >  	down_write(&fw_device_rwsem);
> > -	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
> > -	      idr_get_new(&fw_device_idr, device, &minor) :
> > -	      -ENOMEM;
> > +	ret = idr_alloc(&fw_device_idr, device, 0, 0, GFP_KERNEL);
> >  	up_write(&fw_device_rwsem);
> >  
> >  	if (ret < 0)
> >  		goto error;
> > +	minor = ret;
> >  
> >  	device->device.bus = &fw_bus_type;
> >  	device->device.type = &fw_device_type;
> 
> This hunk is OK, of course.

Could be changed into

	ret = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS, GFP_KERNEL);

though, which would be an additional bug fix.
-- 
Stefan Richter
-=====-===-= --=- ---==
http://arcgraph.de/sr/
