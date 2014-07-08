Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaGHFRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:17:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58269 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaGHFRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:17:04 -0400
MIME-Version: 1.0
Date: Tue, 8 Jul 2014 01:17:02 -0400
Message-ID: <CAGi9MxXckC4NrQudjSP3qKteV1Vo-gATmsiRTxRMp1DR1y_ONg@mail.gmail.com>
Subject: Can I use DEVICE_INT_ATTR() so that probing and removing sysfs
 enteries happens automatically?
From: Jamie Risk <jamie@subject2risk.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Risk <jamie@subject2risk.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the proper way to use the 'DEVICE_(INT|ULONG|BOOL)_ATTR()'
macros with a platform driver? Or, am I best using per attribute pairs
of show/store functions?

If I code my own 'show()' and 'store()' functions and use the
'DEVICE_ATTR()' macros things work happily with an assignment of
'struct attribute_group * attr_groups[];' to the 'struct
device_driver' 'groups' field. i.e.

    static struct platform_driver platform = { /* ... */ .driver = {
.groups = attr_groups, /* ... */ }, };

If I use the 'DEVICE_INT_ATTR()' macro (for
'device_(show|store)_int()' utility) the attribute appears in sysfs,
but accesses cause an OOPs: 'device_show_int()' is called via
'drv_attr_show()' with an inappropriate signature.

Whats a correct/corrected approach?

- Jamie
