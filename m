Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab3GPQpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:45:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016Ab3GPQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:45:31 -0400
Date: Tue, 16 Jul 2013 09:44:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: driver model, duplicate names question
Message-ID: <20130716164459.GB17827@kroah.com>
References: <51E57631.2030805@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E57631.2030805@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:34:57AM -0700, Srinivas Pandruvada wrote:
> Hi Greg,
> 
> I would like to create tree like structure using device model (struct 
> device, device_register/device_unregister) using parent/child 
> relationship while creation. I want to be able to create duplicate 
> names, when their parents are different, similar to a directory structure.
> I see that I can't create devices with duplicate names (device names), 
> even when their parents are different.

We actually check that?  Nice, I didn't realize that :)

> How can I allow duplicate names when their parents are different devices?
> I want to avoid flat model as I have parent child relationship and there 
> will be too many devices using flat model.

Devices on the same bus shouldn't have the same name, but if they are in
a "tree", it should be ok.  What check is erroring out?

> Why, I need?
> I am going to publish RFC for a new power cap class driver. We have a 
> multiple controllers under power cap class (they are devices). Under 
> which there are multiple power zones, with parent/child relationships. 
> Currently I have to use  kobject_init_and_add, which I want to avoid and 
> just use device_register. Other places, wherever such relationships are 
> required, kobjects are used like cpufreq.

Yes, you shouldn't use "raw" kobject calls at all, so we should fix
this.

thanks,

greg k-h
