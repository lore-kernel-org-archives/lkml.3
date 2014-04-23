Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaDWWsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:48:20 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65061 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbaDWWsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:48:16 -0400
Message-ID: <5358432F.8040202@gmail.com>
Date: Wed, 23 Apr 2014 15:48:15 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] sysfs, device-tree: aid for debugging device tree boot
 problems
References: <53571685.5060403@gmail.com> <20140423032044.GA26233@kroah.com> <20140423115418.A8C0EC40969@trevor.secretlab.ca>
In-Reply-To: <20140423115418.A8C0EC40969@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/2014 4:54 AM, Grant Likely wrote:
> On Tue, 22 Apr 2014 20:20:44 -0700, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> On Tue, Apr 22, 2014 at 06:25:25PM -0700, Frank Rowand wrote:
>>> Create some infrastructure to aid trouble shooting device tree related
>>> boot issues.
>>>
>>> Add a %driver_name file to each device tree node sysfs directory which has had
>>> a driver bound to it.  This allows detecting device tree nodes which failed
>>> to be bound to any driver.
>>
>> Why is this needed, shouldn't there already be a "driver" symlink in
>> sysfs for these devices when a driver binds to them?  The rest of the
>> driver model works that way, why is of devices any different?
>>
> 
> Because it hasn't been added yet! I only just committed the change to
> convert device_nodes into kobjects in v3.14. The next step is to add
> driver symlinks.

No need to add a "driver" symlink.  The device directories in sysfs already
have a driver symlink.

> 
> That said, the devicetree node is already exposed in the uevent for a
> device. It should already be possible to find all device tree nodes that
> don't have a device, or devices without a driver:
> 
> To get a list of all nodes:
> 
> find /proc/device-tree/ -type d | sed -e 's/\/proc\/device-tree//'
> 
> or a little more nuanced, only choosing nodes with a compatible property:
> 
> for k in `find /proc/device-tree/ -name compatible`; do
> 	echo $(dirname $k) | sed -e 's/\/proc\/device-tree//'
> done | sort
> 
> It can get even more refined than that if need be.
> 
> To get a list of all nodes with a device that has been created:
> 
> for k in `find devices -name uevent`; do
> 	grep '^OF_FULLNAME' $k | sed -e 's/OF_FULLNAME=//'
> done | sort

< snip >

Thanks Grant!  I did not realize that uevent contained that
information.

-Frank

