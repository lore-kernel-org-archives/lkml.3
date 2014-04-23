Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaDWDUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 23:20:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDWDUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 23:20:19 -0400
Date: Tue, 22 Apr 2014 20:20:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frank Rowand <frowand.list@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] sysfs, device-tree: aid for debugging device tree boot
 problems
Message-ID: <20140423032044.GA26233@kroah.com>
References: <53571685.5060403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53571685.5060403@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 06:25:25PM -0700, Frank Rowand wrote:
> Create some infrastructure to aid trouble shooting device tree related
> boot issues.
> 
> Add a %driver_name file to each device tree node sysfs directory which has had
> a driver bound to it.  This allows detecting device tree nodes which failed
> to be bound to any driver.

Why is this needed, shouldn't there already be a "driver" symlink in
sysfs for these devices when a driver binds to them?  The rest of the
driver model works that way, why is of devices any different?

> Examples of using the %driver_name file (note that /proc/device-tree is a
> link to the base of the device tree sysfs tree):
> 
> 
>   1) To find list of device tree nodes with no driver:
> 
>   # A few false positives may be reported.  For example,
>   #   node_full_path of "." is the board.
>   #
>   # output is: node_full_path compatible_string
>   #
>   cd /proc/device-tree
>   for k in `find . -type d`; do
>      if [[ -f ${k}/compatible && ! -f ${k}/%driver_name ]] ; then
>         if [[ "`cat ${k}/compatible`" != "simple-bus" ]] ; then
>            echo `echo ${k} | sed -e 's|./||'` `cat ${k}/compatible`
>         fi
>      fi
>   done | sort
> 
> 
>   2) To find list of device tree nodes with a bound driver:
> 
>   # output is:  node_full_path driver_name
>   #
>   cd /proc/device-tree
>   for k in `find . -name %driver_name` ; do
>      echo `echo ${k} | sed -e 's|./||' -e 's|/%driver_name$||'` `cat ${k}`
>   done | sort
> 
> 
>   3) To find list of device tree nodes with a bound driver:
> 
>   # output is:  driver_name node_full_path
>   #
>   cd /proc/device-tree
>   for k in `find . -name %driver_name` ; do
>      echo `cat ${k}` `echo ${k} | sed -e 's|./||' -e 's|/%driver_name$||'`
>   done | sort

If we take this patch, these examples should be somewhere in the
documentation to make it easy for others.

> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>

Minor nit, your From: line doesn't match this signed-off-by: so
something has to change (or add a new From: line, like SubmittingPatches
decribes how to do.)

thanks,

greg k-h
