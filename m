Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbbABQb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:31:26 -0500
Received: from forward11.mail.yandex.net ([95.108.130.93]:46626 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbbABQbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:31:25 -0500
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2015 11:31:24 EST
From: Alex Kuznetsoff <dri-devel@yandex.ru>
To: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Radeon R9 290 problem
MIME-Version: 1.0
Message-Id: <1791051420215815@web16j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 02 Jan 2015 23:23:35 +0700
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an AMD Radeon R9 290 video card, and since commit https://github.com/torvalds/linux/commit/96212fe8c27b I cannot boot into the system any more with CONFIG_DRM_RADEON turned on ([m]). These are the symptoms: the screen either reports NO SIGNAL (sometimes all the LEDs, scroll lock, caps lock and num lock start to blink synchronously) - I had a lot of this while bisecting v3.12.0 to v3.13.0, or, in newer kernels, including v3.18, the image just freezes somewhere around "Waiting for uevents to be processed" and nothing more happens on the screen. In both cases I have to use the reboot button.

Here's the output of lspci | grep ATI:

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Hawaii PRO [Radeon R9 290]
01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Device aac8

Here's my kernel config:

https://bpaste.net/show/8c353c80e37e

It works in 3.12 series up to 3.12.34 (it is the last version I checked) and doesn't work in 3.13 to v3.18 (b2776bf).
