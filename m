Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3CAFHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:07:18 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:55446 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3CAFHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:07:01 -0500
Date: Thu, 28 Feb 2013 21:07:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-usb@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/2] ACPI / glue: Add .match() callback to struct
 acpi_bus_type
Message-ID: <20130301050706.GB25192@kroah.com>
References: <2612891.I2roH54cPk@vostro.rjw.lan>
 <20130228023313.GC4042@kroah.com>
 <1504144.f1SBuDyFqp@vostro.rjw.lan>
 <194591401.DiJi7SfL1g@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194591401.DiJi7SfL1g@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 10:53:21PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> USB uses the .find_bridge() callback from struct acpi_bus_type
> incorrectly, because as a result of the way it is used by USB every
> device in the system that doesn't have a bus type or parent is
> passed to usb_acpi_find_device() for inspection.
> 
> What USB actually needs, though, is to call usb_acpi_find_device()
> for USB ports that don't have a bus type defined, but have
> usb_port_device_type as their device type, as well as for USB
> devices.
> 
> To fix that replace the struct bus_type pointer in struct
> acpi_bus_type used for matching devices to specific subsystems
> with a .match() callback to be used for this purpose and update
> the users of struct acpi_bus_type, including USB, accordingly.
> Define the .match() callback routine for USB, usb_acpi_bus_match(),
> in such a way that it will cover both USB devices and USB ports
> and remove the now redundant .find_bridge() callback pointer from
> usb_acpi_bus.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
