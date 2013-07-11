Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab3GKX7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:59:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39087 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854Ab3GKX7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:59:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 0/30] ACPI / hotplug / PCI: Major rework + Thunderbolt workarounds
Date: Fri, 12 Jul 2013 01:34:20 +0200
Message-ID: <3718119.FLASu5DBx8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <26431283.HJCKsss0rt@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've made some progress with my ACPIPHP rework since I posted the series last
time and here goes an update.

First off, the previous series was somewhat racy, which should be fixed now.
Apart from this there's quite some new material on top of the patches I posted
last time (or rather on top of their new versions) and I integrated the
Thunderbolt series from Mika with that.  As a result,

https://patchwork.kernel.org/patch/2817341/

is required to be applied.

Still untested, still based on 3.10 with ACPI+PM 3.11 material merged on top,
but this time I don't have any plans to add more patches to the series for the
time being.  Also 3.11-rc1 should be out in a couple of days, so I'll be able
to integrate this work with the previous cleanups series from Gerry and myself
on top of it.

I did my best not to change too much at a time and some steps add stuff that
is removed by the subsequent ones, so hopefully it is bisectable.

If anyone finds something questionable or outright bogus in these patches,
please let me know before it's too late. ;-)

[ 1/30] Make bus registration and unregistration symmetric.  [Resend]
[ 2/30] Consolidate acpiphp_enumerate_slots().  [Resend]
[ 3/30] Fix error code path in register_slot().  [Resend]
[ 4/30] Introduce hotplug context objects for ACPI device objects corresponding
        to PCI hotplug devices.  [Update]
[ 5/30] Unified notify handler for hotplug events.  [Update]
[ 6/30] Drop acpiphp_handle_to_bridge() and use context objects instead of it.  [Update]
[ 7/30] Pass entire hotplug context objects (instead of their fields
        individually) to event handling work functions.  [Update]
[ 8/30] Merge hotplug event handling functions.  [Update]
[ 9/30] Drop func field from struct acpiphp_bridge.
[10/30] Refactor slot allocation code in register_slot().
[11/30] Make acpiphp_enumerate_slots() to register all devices on the given bus
        and install the notification handler for all of them.
[12/30] Drop sun field from struct acpiphp_slot.
[13/30] Use common slot count variable in register_slot().
[14/30] Drop flags field from struct acpiphp_bridge.
[15/30] Embed function structure into struct acpiphp_context.
[16/30] Drop handle field from struct acpiphp_func.
[17/30] Drop handle field from struct acpiphp_bridge.
[18/30] Store parent bridge pointer in function objects and bus pointer in slot
        objects.
[19/30] Rework ACPI namespace scanning and trimming routines.
[20/30] Drop redundant checks from check_hotplug_bridge().
[21/30] Consolidate slot disabling and ejecting
[22/30] Do not queue up event handling work items for non-hotplug events.
[23/30] Do not execute _PS0 and _PS3 directly.
[24/30] Do not check SLOT_ENABLED in enable_device().  [Thunderbolt series]
[25/30] Allow slots without new devices to be rescanned.  [Thunderbolt series]
[26/30] Check for new devices on enabled slots.  [Thunderbolt series, TBD]
[27/30] Get rid of unused constands in acpiphp.h.  [Thunderbolt series]
[28/30] Sanitize acpiphp_get_(latch)|(adapter)_status().  [Thunderbolt series]
[29/30] Redefine enable_device() and disable_device() (rename and change to void).
[30/30] Clean up the usage of bridge_mutex.

Patch [26/30] seems to go over the top with dropping the non-responsive devices
and it probaby needs some more thought.  Also the algorithm of bus checks and
device checks may need to be improved in the future, but for the time being I
think it is good enough.

Comments welcome!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
