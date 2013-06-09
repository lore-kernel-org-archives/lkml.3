Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3FIXCC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 19:02:02 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45794 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3FIXB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 19:01:59 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-acpi@vger.kernel.org
Cc: seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl
Subject: [PATCH 0/3] Fix backlight issues on some Windows 8 systems 
Date: Sun,  9 Jun 2013 19:01:36 -0400
Message-Id: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.2.1
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows 8 introduced new policy for backlight control by pushing it out to
graphics drivers. This appears to have coincided with a range of vendors
adding Windows 8 checks to their backlight control code which trigger either
awkward behaviour (Lenovo) or complete brokenness (some Dells). The simplest
thing to do would be to just disable ACPI backlight control entirely if the
firmware indicates Windows 8 support, but it's entirely possible that
individual graphics drivers might still make use of the ACPI functionality in
preference to native control.

The first two patches in this series are picked from other patchesets aimed at
solving similar problems. The last simply unregisters ACPI backlight control
on Windows 8 systems when using an Intel GPU. Similar code could be added to
other drivers, but I'm reluctant to do so without further investigation as
to the behaviour of the vendor drivers under Windows.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

