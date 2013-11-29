Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3K2Bir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:38:47 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:58499 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3K2Biq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:38:46 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware (testers needed)
Date: Fri, 29 Nov 2013 02:35:37 +0100
Message-Id: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thunderbolt hotplug is supposed to be implemented by the firmware. But Apple's
firmeware only initializes devices during boot and ignores hotplugged devices.
This patch series adds a driver for the Intel Cactus Ridge Thunderbolt
controller. The driver supports hotplug operations of simple (one PCI device,
no chaining) thunderbolt devices.

The patches in this series are self contained and I have tried to sort them
(roughly) from lowest to highest level of abstraction. They all compile but
only the final driver has been tested.

The driver works on my MacBookPro10,1 with two Thunderbolt ethernet adapters.
The system contains the Cactus Ridge C4 TB controller (device id 0x1547). I
could not run tests on other systems, but there is a good chance that the
driver will work on other models as well. If something is controller specific
then it should be confined to patch 01.

There are still a number of limitations:
 (1) The system must be booted with acpi_osi=Darwin. Otherwise ACPI will cut
power to the controller.
 (2) After suspend the controller is gone. I think that ACPI thinks that we are
Windows and cuts power, even with acpi_osi=Darwin.
 (3) No support for chaining. Also the driver only activates the first PCI
device found on a Thunderbolt device.
 (4) Rapidly replugging a device confuses pciehp.

(1) and (2) should be solveable given some time. I also have a pretty good idea
on how chaining should work. The main problem is that I have yet to see any
Thunderbolt device besides the Apple ethernet adapter. If someone with a
MacBook and access to more complicated TB hardware is willing to run some
tests: Please contact me.

I will try to debug (4) further and write a seperate bug report for the issue.

Andreas

