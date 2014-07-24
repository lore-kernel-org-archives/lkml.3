Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434AbaGXSUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:20:23 -0400
Received: from mout.gmx.net ([212.227.15.19]:51204 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933391AbaGXSUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:20:20 -0400
Message-ID: <53D14E60.1010105@gmx.de>
Date: Thu, 24 Jul 2014 20:20:16 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, ceph-devel@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: sizeof (struct tYpO *) : it is just a typo or rather a bug ?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:9Y3UWQTGJBlQcpdF1JkO9gHuo5ElI8/fpKW5gvcWe/m2c/w8zan
 TzKfahRR7ed5bOfhh2veuhLZqlQNGyjiaklIdKW6xrM9I69wSn9Lmex8yE5EqMbDqZ5LFF1
 b8Qv7A0biCyQXYzwXz9ss8OYa5W+wxrSWaVo0b905bmsft1aX9/SpiNVpra60mncn2mg09G
 Cdr8QWYIU5TFpuFrkfanA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by this "typo" fix 
http://article.gmane.org/gmane.linux.kernel/1754640
I grep'ed the current git tree of linus for similar issues.

For these 4 places I'm wondering where the appropriate struct definition is located :

arch/ia64/sn/kernel/io_acpi_init.c:         sizeof(struct pci_devdev_info *)) {
tools/perf/builtin-sched.c:     sched->tasks = realloc(sched->tasks, sched->nr_tasks * sizeof(struct task_task *));
fs/ceph/xattr.c:                xattrs = kcalloc(numattr, sizeof(struct ceph_xattr *),
fs/ceph/xattr.c:                memset(xattrs, 0, numattr*sizeof(struct ceph_xattr *));

Nevertheless I was told, that gcc doesn't complain about such things due to eventually evaluating it to "sizeof(null)". I'm however curious if at least a warning should be emitted in such a case, or?

-- 
Toralf

