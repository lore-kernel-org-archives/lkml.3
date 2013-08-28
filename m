Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3H1NlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:41:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39539 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab3H1NlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:41:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 0/2] driver core / ACPI: Avoid device removal locking problems
Date: Wed, 28 Aug 2013 15:45:59 +0200
Message-ID: <26495758.n1zOCiG3iV@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1592448.YZbpON5n7n@vostro.rjw.lan>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan> <20130828122422.GA18348@mtj.dyndns.org> <1592448.YZbpON5n7n@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following two patches are to address possible deadlocks related to
device removal and device sysfs attribute access.  In short, some device
sysfs attribute callbacks need to acquire locks that are also held around
device removal and that may lead to deadlocks with s_active draining in
sysfs_deactivate().

[1/2] Avoid possible device removal deadlocks related to device_hotplug_lock.
[2/2] Rework the handling of containers by ACPI hotplug (which makes a possible
      device removal deadlock related to acpi_scan_lock go away).

On top of linux-next, for v3.12.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
