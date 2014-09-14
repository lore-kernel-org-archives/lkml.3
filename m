Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaINKS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:18:28 -0400
Received: from forward5l.mail.yandex.net ([84.201.143.138]:56090 "EHLO
	forward5l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaINKS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:18:27 -0400
X-Yandex-Uniq: 05e75c09-e17a-485b-b637-47c95483c843
Authentication-Results: smtp2h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 0/3] Implement /proc/built-in file similar to /proc/modules
From: Kirill Tkhai <tkhai@yandex.ru>
To: mmarek@suse.cz, arnd@arndb.de, linux-kbuild@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, grant.likely@secretlab.ca, ebiederm@xmission.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, sam@ravnborg.org
Date: Sun, 14 Sep 2014 14:18:13 +0400
Message-ID: <20140914100545.3745.23394.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements a possibility to show the list of built-in drivers
to userspace. The names of drivers will be the same as when they are modules.
So, if your system has "loop" driver then it appears either in /proc/modules
or in /proc/built-in and userspace will be able to know about this.

Now this is impossible. The only way to get kernel configuration is
/proc/config.gz, but CONFIG_* names can change from time to time. Module
names are more or less standardized.

---

Kirill Tkhai (3):
      kbuild: Make targets names tree-wide unique on x86
      core: Save list of built-in drivers names
      core: create /proc/built-in file to show the list of built-in drivers


 drivers/acpi/acpica/Makefile      |   28 +++++++--------
 drivers/pnp/pnpacpi/Makefile      |    4 +-
 fs/proc/Makefile                  |    1 +
 fs/proc/builtin.c                 |   70 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |    3 ++
 init/Makefile                     |   19 ++++++----
 scripts/Makefile.build            |   14 +++++--
 7 files changed, 112 insertions(+), 27 deletions(-)
 create mode 100644 fs/proc/builtin.c

--
Signed-off-by: Kirill Tkhai <kthai@parallels.com>
