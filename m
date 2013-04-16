Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3DPFYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 01:24:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27331 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3DPFYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 01:24:09 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -v6 0/4] x86, kdump: Fix crashkernel high with old kexec-tools
Date: Mon, 15 Apr 2013 22:23:44 -0700
Message-Id: <1366089828-19692-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek found some problems with old kexec-tools.

We keep the old crashkernel=X to old behavoir, so it will not break
old kexec-tools.
Add crashkernel=X,high to support new kexec-tools that supports loading high.
when high is used, memblock will search from top to low.
if the allocated one is above 4G, kernel will try to auto allocate
72M under 4G for swiotlb.
user could crashkernel=Y,low to change 72M to other value.

-v2:	reorder the patch sequences
	crashkernel=X,high, crashkernel=Y,low only handle simple form.
	crashkernel=X will override crashkernel=X;high crashkernel=Y;low
-v3:	update description in kernel-parameters.txt
	update get_last_crashkernel and _simple checking about suffix.
-v4:	update to use ,high again, and also not abuse parse_crashkernel_simple
-v5:	tight checking about crashkernel=X,highextra,high
-v6:	update one comments according to hpa.

Thanks

Yinghai
