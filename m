Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbaCTUxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:53:38 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64862 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197AbaCTUxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:53:36 -0400
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH RFC 0/1] PM / Hibernate: no kernel_power_off when pm_power_off
Date: Thu, 20 Mar 2014 13:53:14 -0700
Message-Id: <1395348795-8554-1-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to avoid calling kernel_power_off when pm_power_off is null.
When pm_power_off is null, the platform will not power off in
kernel_power_off.  Currently, hibernate will call kernel_power_off and
then move on to kernel_halt.  However, this calls the notifier chain
twice with a different parameter.  In kernel/reboot.c, this is avoided
by checking if pm_power_off is NULL and bypassing kernel_power_off.

Mostly, this is a check if anyone is dependent on having the reboot
notifier called 2x if pm_power_off is null.  There are some panics if
it's called this way in some drivers.

Tested this on omap beaglebone black, but have not tried on other
hardware.  Please let me know if you can test this on another platform
and the results.

Thanks,

Sebastian
