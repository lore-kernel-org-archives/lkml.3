Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398Ab3GRUkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:40:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab3GRUkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:40:42 -0400
Date: Thu, 18 Jul 2013 13:40:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: rjw@sisk.pl, arjan@linux.intel.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v00 1/1] PowerCap: Documentation
Message-ID: <20130718204050.GA20750@kroah.com>
References: <1374176055-23527-1-git-send-email-srinivas.pandruvada@linux.intel.com>
 <1374176055-23527-2-git-send-email-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374176055-23527-2-git-send-email-srinivas.pandruvada@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:34:15PM -0700, Srinivas Pandruvada wrote:
> Added power cap framework documentation. This explains the use of power capping framework,
> sys-fs and programming interface.

Minor nit, it's called "sysfs" no '-' anywhere in the name please.

> +Experimental implantation is using two options:
> +Option 1: Use simple device model. Since we can't have duplicate file names under
> +a class even if there parents are different (Unlike a Linux directory tree), each
> +child will be named using their hierarchy in the tree. For example, a RAPL power
> +zone such as a CPU package can be called intel-rapl-0, then its children will be
> +named as intel-rapl-0:0, intel-rapl-0:1 etc.
> +
> +Option 2: Each controller is a device and zones and constraints under it are
> +created using kobjects. Here exact names of power zones can be used in the sys-fs
> +file names.

Don't ever use "raw" kobjects in the device tree, that way is crazy,
userspace can never see the devices, and you end up having to duplicate
all of the logic that the driver core creates for you.

In short, don't do that, as I will not accept such code into the kernel,
sorry.  Work with the driver model, don't get hung up on the names not
being able to be "the same", that restriction is there for a reason, as
you found out (it is exactly like a Linux directory tree, unlike your
statement above, as those names all end up in the same directory in
sysfs, which is why the restriction is there.)

hope this helps,

greg k-h
