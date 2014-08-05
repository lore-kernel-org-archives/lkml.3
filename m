Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbaHEPMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:12:48 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:61326 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaHEPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:12:46 -0400
From: Aurelio Colosimo <aurelio.colosimo@gmail.com>
X-Google-Original-From: Aurelio Colosimo <aurelio@aureliocolosimo.it>
To: Thierry Reding <thierry.reding@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Aurelio Colosimo <aurelio@aureliocolosimo.it>
Subject: [PATCH 0/2] pwm: some improvements to sysfs interface
Date: Tue,  5 Aug 2014 17:12:16 +0200
Message-Id: <1407251538-17566-1-git-send-email-aurelio@aureliocolosimo.it>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds two more features in pwm sysfs, which I
developed for the driver of my pwm device (a virtualization of
AVR pwm outputs, not submitted to mainline yet):
    
- an optional static name for each pwm device, so that driver develop
  can give a name to the output itself, in a similar way as gpio system
  does;
    
- the attribute 'max', and the attribute 'resolution', in
  nanoseconds, specific for each pwm device.
    
  Each new field is initialized with a default (meaningful) value;
  anyway, if desired, pwm drivers maintainers should fix their
  drivers in order to use the new fields.
    
Aurelio Colosimo (2):
  pwm: new field name added to pwm_device
  pwm: new fields, max and resolution, added to sysfs

 drivers/pwm/core.c  |  2 ++
 drivers/pwm/sysfs.c | 29 ++++++++++++++++++++++++++++-
 include/linux/pwm.h |  3 +++
 3 files changed, 33 insertions(+), 1 deletion(-)

