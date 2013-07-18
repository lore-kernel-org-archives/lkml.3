Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab3GRAVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:21:24 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44721 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab3GRAVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:21:21 -0400
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: adurbin@chromium.org, olofj@chromium.org, axel.lin@ingics.com
Subject: [PATCH 0/2] Platform: x86: chromeos_laptop - Deferred Probing
Date: Wed, 17 Jul 2013 17:20:59 -0700
Message-Id: <1374106861-3549-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series refactors the dmi check system and
returns -EPROBE_DEFER when an expected i2c adapter is not present
at probe time.

This will allow the touchpad, touchscreen, and light sensors on
Pixel to load even if the i915 DDC and PANEL buses are instantiated
after chromeos_laptop.

[PATCH 1/2] Platform: x86: chromeos_laptop - Restructure device associations
[PATCH 2/2] Platform: x86: chromeos_laptop - Use deferred probing
