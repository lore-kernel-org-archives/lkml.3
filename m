Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3EML5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 07:57:52 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54748 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3EML5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 07:57:50 -0400
Date: Mon, 13 May 2013 04:58:01 -0700
From: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux PM list (linux-pm@vger.kernel.org)" <linux-pm@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: Re: Kobject_uevent in cpufreq.c
Message-ID: <20130513115801.GA11433@kroah.com>
References: <4D68720C2E767A4AA6A8796D42C8EB59C8D667@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB59C8D667@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:31:57AM +0000, R, Durgadoss wrote:
> Hi,
> 
> I am observing an UEvent issue in cpufreq.c. 
> The cpufreq_add_dev() function is called whenever a core is 'onlined'.
> we expect the kobject_uevent() method in cpufreq_add_dev() to
> send an UEvent with KOBJ_ADD as the action parameter.
> 
> But this call fails because of the 'filter function' inside kobject_uevent_env
> inside lib/kobject_uevent.c. The ->filter points to 'dev_uevent_filter' in
> drivers/base/core.c, where the check for 'device_ktype' fails.
> 
> Error message:
> kobject: 'cpufreq' (e5bbf290): kobject_uevent_env:
> filter function caused the event to drop!
> 
> As far as I can see, we need a kset, and associated filter function
> inside cpufreq.c to get this working. Is this the right way to go ?
> Any other easy/correct ways to get it working ? Please advise.

What exactly are you trying to do, and want the kernel to do?  You
already get on/offline events for CPUs, why do you want them for cpufreq
devices as well?

thanks,

greg k-h
