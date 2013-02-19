Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab3BSDIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:08:05 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45081 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab3BSDIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:08:02 -0500
Date: Tue, 19 Feb 2013 11:07:52 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, akpm@linux-foundation.org
Subject: [bug]patch "acpi, memory-hotplug: parse SRAT before memblock is
 ready" breaks numa detection
Message-ID: <20130219030752.GA30739@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch in linux-next breaks numa detection. numa_init() will zero
numa_meminfo. If acpi_numa_init() does not call early_parse_srat(), we will
have no memory numa info.

Thanks,
Shaohua
