Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422743Ab3CWA1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 20:27:34 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49310 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3CWA1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 20:27:32 -0400
MIME-Version: 1.0
Date: Fri, 22 Mar 2013 17:27:32 -0700
X-Google-Sender-Auth: xoAZg8DsuonCqMT3QtIXuC4-6ws
Message-ID: <CAE9FiQVZ5VZDo1KCun6SDonTJ=TGWLxm5zJQN5U4f1_52cKKwg@mail.gmail.com>
Subject: pm/linux-next cause network stop working with qemu-kvm/e1000
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Bob Moore <robert.moore@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c13085e519e8984fede41fa3d6a5502523b10996 is the first bad commit
commit c13085e519e8984fede41fa3d6a5502523b10996
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Mar 8 09:19:38 2013 +0000

    ACPICA: Resource Mgr: Prevent infinite loops in resource walks

    Add checks for zero-length resource descriptors in all code that
    loops through a resource descriptor list. This prevents possible
    infinite loops because the length is used to increment the traveral
    pointer and detect the end-of-descriptor.

    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lv Zheng <lv.zheng@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

:040000 040000 84f29d6ee654ffe4c935ce9023208019b2ef09a5
c8a6613be9a5a130f69e654c5b560a8adb2174db M	drivers


long delay after
calling  ip_auto_config+0x0/0xea4 @ 1

also happen on one 8 sockets nehalem-ex.

If I revert that commit, network works again.

Thanks

Yinghai
