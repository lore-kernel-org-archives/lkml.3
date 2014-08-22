Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbaHVRk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:40:26 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34893 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbaHVRkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:40:22 -0400
MIME-Version: 1.0
Date: Fri, 22 Aug 2014 10:40:20 -0700
Message-ID: <CA+zRj8WfK3Dgcx2F-eOJ10ZroZaZDdB6NYp6SLpBs2eOu2bUOA@mail.gmail.com>
Subject: i915: Regression: +4W in idle power use on Macbook Pro 15 (late 2013)
From: Eric Rannaud <eric.rannaud@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Jon Kristensen <info@jonkri.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Between 3.15.4 and 3.15.8, there was an increase in idle power consumption on
Apple Macbook Pro 15 (late 2013) on a freshly booted system (no wifi driver
loaded; brightness set to 4/100; X running; no desktop environment, except
Awesome), from 6.5W to about 10.5W, as reported by powertop.

In the stable tree, it bisects to:
        commit f4db98240ac2c6d9d2118c6f82d483ff5293f1ed
        Author: Chris Wilson <chris@chris-wilson.co.uk>
        Date:   Fri Jun 6 10:37:11 2014 +0100

            drm/i915: Disable FBC by default also on Haswell and later

            commit 0368920e51ae0cded0eb518c340a4dd17764d461 upstream.

            It causes black screen on bootup and is approximately 100x
slower than
            running with FBC disabled, so the GPU runs at a high
frequency for much
            longer - completely contrary to the power saving claims.
It also still
            has mutex deadlocks in multi-head scenarios, which can lead to a
            system/X lockup. These bugs were known before FBC was
enabled by default
            on Haswell and still have not been fixed.

The issue is still present in Linus' tree (v3.17-rc1-22-g480cadc2b7e0).

With a 75Wh battery, that's a significant loss in battery life in normal use.

I'll be happy to help test any potential fix.

Thanks,
Eric
