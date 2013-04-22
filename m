Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3DVNTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:19:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3DVNTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:19:03 -0400
Subject: memcpy_fromio in dmi_scan.c
From: Jean Delvare <jdelvare@suse.de>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 22 Apr 2013 15:18:09 +0200
Message-ID: <1366636689.4503.35.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Duan, Andrew,

I am looking at the following commit:

commit 9f9c9cbb60576a1518d0bf93fb8e499cffccf377
Author: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Date:   Thu Dec 20 15:05:14 2012 -0800

    drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists

And I am worried about calls to memcpy_fromio(), or lack thereof. Before
this commit, the code would take great care to always call
memcpy_fromio() to get data from the 0xF0000-0xFFFFF memory range (BIOS
data) and operate on that copy. After this commit, the code is happily
calling memcmp() directly on an __iomem pointer. It seems to be harmless
on x86, but it will break on IA64, won't it?

-- 
Jean Delvare
Suse L3

