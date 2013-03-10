Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3CJXPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 19:15:10 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52004 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJXPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 19:15:07 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 10 Mar 2013 18:15:02 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 0/8] watchdog: w83627hf: Convert to watchdog infrastructure
Date: Sun, 10 Mar 2013 16:14:53 -0700
Message-Id: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to watchdog infrastructure, cleanup, add support for additional
chips, and merge with W83697HF and W83697UG watchdog drivers.

Tested with W83627UHG, NCT6775, NCT6776. Additional test feedback
for other chips would be appreciated.

Original idea was to prepare the driver for use as a client to an MFD driver,
but I found that requesting memory with request_muxed_region works just as well
and has less impact. v2 includes the knowledge gained from converting the
driver to an MFD client driver, but without the actual conversion.

v2: Tested with W83627UHG
    Retain timeout module parameter; use watchdog_init_timeout to set it
    Eliminate some cosmetic changes
    Drop spinlock.h include
    Keep "initialized" message
    Don't try to configure WDTO for W83627UHG and W83627EHF
    Don't report the nowayout option with the 'initializing' message
    Use request_muxed_region to reserve memory range only while needed
    Add support for W83627S, W83627DHG-P, W83667HG, and NCT6779
