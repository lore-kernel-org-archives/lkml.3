Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3DADDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:03:52 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:49719 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab3DADDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:03:50 -0400
Date: Sun, 31 Mar 2013 20:03:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH 1/2] USB / PM: Don't try to hide PM QoS flags from
 usb_port_device_release()
Message-ID: <20130401030347.GC20857@kroah.com>
References: <512F8980.4040809@oracle.com>
 <2829731.BFs3ri3Eud@vostro.rjw.lan>
 <1876128.a4gSDF7byc@vostro.rjw.lan>
 <1651223.ep7oZJM5CX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651223.ep7oZJM5CX@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 12:57:21AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Remove the call to dev_pm_qos_hide_flags(), added by commit 6e30d7cb
> "usb: Add driver/usb/core/(port.c,hub.h) files", from
> usb_port_device_release(), because (1) it is completely unnecessary
> (the flags have been removed already by the PM core during the
> unregistration of the device object) and (2) it triggers a NULL
> pointer dereference in sysfs_find_dirent() (dev->kobj->sd is NULL at
> this point).
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
