Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3GNXGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:06:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3GNXGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:06:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, oliver@schinagl.nl, linux@roeck-us.net
Subject: [PATCH v3 01/10] Driver core and sysfs changes for attribute groups
Date: Sun, 14 Jul 2013 16:05:50 -0700
Message-Id: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is the third iteration of the patchset to add better attribute
group support to the driver core and sysfs.

Others have now tested it, and we got 3 more patches fixing a warning
that was showing up when binary attributes were in a group with no
"normal" attributes, and some more helper macros were added and cleaned
up.

I've booted this successfully against 3.11-rc1 with no problems (am
sending these from that machine.)

Ian, I didn't add a DEVICE_PATTR() macro yet, that can come later.  I
considered it, but that would also mean a BUS_PATTR() and the like, which I
guess works, but I hate even a _hint_ of "Hungarian" notation, which this
implies.

Anyone else have a better name for this macro:
	#define DEVICE_PATTR(_name)	&dev_attr_##_name.attr
that they can think of?  It will cut down on the typing done for
attribute lists.

changes from v3:
	- tested by Guenter
	- patches from Oliver added
	- refreshed on 3.11-rc1 (minor fuzz)
	- Ian glanced at them.

changes from v2:
	- actually boots
	- 7th patch added properly
	- added BUS_ATTR, CLASS_ATTR, and DRIVER_ATTR RW and RO macros
	  to help with converting code to use attributes properly.

thanks,

greg k-h

