Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaJBAEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 20:04:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaJBAEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 20:04:21 -0400
Date: Wed, 1 Oct 2014 17:03:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 02/15] Driver core: Unified device properties
 interface for platform firmware
Message-ID: <20141002000325.GC17093@kroah.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1852462.V1jlbi8OPt@vostro.rjw.lan>
 <7184313.9OdTqVa2eQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7184313.9OdTqVa2eQ@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 04:10:03AM +0200, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> Add a uniform interface by which device drivers can request device
> properties from the platform firmware by providing a property name
> and the corresponding data type.  The purpose of it is to help to
> write portable code that won't depend on any particular platform
> firmware interface.
> 
> Three general helper functions, device_get_property(),
> device_read_property() and device_read_property_array() are provided.
> The first one allows the raw value of a given device property to be
> accessed.  The remaining two allow the value of a numeric or string
> property and multiple numeric or string values of one array
> property to be acquired, respectively.  Static inline wrappers are also
> provided for the various property data types that can be passed to
> device_read_property() or device_read_property_array() for extra type
> checking.
> 
> In addition to that, new generic routines are provided for retrieving
> properties from device description objects in the platform firmware
> in case a device driver needs/wants to access properties of a child
> object of a given device object.  There are cases in which there is
> no struct device representation of such child objects and this
> additional API is useful then.  Again, three functions are provided,
> device_get_child_property(), device_read_child_property(),
> device_read_child_property_array(), in analogy with device_get_property(),
> device_read_property() and device_read_property_array() described above,
> respectively, along with static inline wrappers for all of the propery
> data types that can be used.  For all of them, the first argument is
> a struct device pointer to the parent device object and the second
> argument is a (void *) pointer to the child description provided by
> the platform firmware (either ACPI or FDT).
> 
> Finally, device_for_each_child_node() is added for iterating over
> the children of the device description object associated with a
> given device.
> 
> The interface covers both ACPI and Device Trees.
> 
> This change set includes material from Mika Westerberg and Aaron Lu.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Greg, please let me know if you're fine with this one.

Looks good to me:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
