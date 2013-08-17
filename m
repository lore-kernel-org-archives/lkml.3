Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3HQU6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 16:58:54 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43810 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3HQU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 16:58:52 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 0/8] watchdog: w83627hf: Convert to watchdog infrastructure
Date: Sat, 17 Aug 2013 13:58:38 -0700
Message-Id: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to watchdog infrastructure, cleanup, add support for additional
chips, and merge with W83697HF and W83697UG watchdog drivers.

Tested with W83627UHG, NCT6775, NCT6776.

Original idea was to prepare the driver for use as a client to an MFD driver,
but I found that requesting memory with request_muxed_region works just as well
and has less impact. v2 includes the knowledge gained from converting the
driver to an MFD client driver, but without the actual conversion.

With this set of patches, the watchdog driver for the supported chips
can be used together with the hwmon driver for those chips.

Wim, please consider merging this set of patches into 3.12. I need
both watchdog and hwmon driver running, which means I have to run
patched kernels which gets a bit annoying over time. If you don't
like the idea of merging the drivers for W83697HF and W83697UG
into this one, please drop patch 6 and 7 from the series.

v3: Reset watchdog trigger on startup
    Rebased to v3.11-rc5

v2: Tested with W83627UHG
    Retain timeout module parameter; use watchdog_init_timeout to set it
    Eliminate some cosmetic changes
    Drop spinlock.h include
    Keep "initialized" message
    Don't try to configure WDTO for W83627UHG and W83627EHF
    Don't report the nowayout option with the 'initializing' message
    Use request_muxed_region to reserve memory range only while needed
    Add support for W83627S, W83627DHG-P, W83667HG, and NCT6779
