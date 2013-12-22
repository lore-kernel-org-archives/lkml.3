Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3LVKLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 05:11:51 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47856 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3LVKLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 05:11:50 -0500
From: Oren Laadan <orenl@cellrox.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>,
        Serge Hallyn <serge@hallyn.com>,
        Eric Biederman <ebiederm@xmission.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Amir Goldstein <amir@cellrox.com>, Oren Laadan <orenl@cellrox.com>
Subject: [PATCH 0/2] Namespace support for Android binder (under ipc-ns)
Date: Sun, 22 Dec 2013 05:07:38 -0500
Message-Id: <cover.1387706794.git.orenl@cellrox.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch-duo adds namespaces support for the Android binder driver. As
discussed in Plumbers 2013, binder is a form of IPC and therefore will be
tied to ipc namespace.

On the ipc-ns side, the implementation is modelled after generic net-ns
pointers (see commit dec827d), but simplified to suit single user/caller
for now, to reduce complexity.

The binder driver registers with ipc-ns and uses the generic pointer to
store and retrieve its namespace data. That is, each namespace maintains
its own binder context manager - which suffices for separation, since all
transactions require binder handles provided by the context manager.

Thanks,

Oren.


Oren Laadan (2):
  ipc namespace: a generic per-ipc pointer and peripc_ops
  binder: implement namepsace support for Android binder driver

 drivers/staging/android/Kconfig  |   1 +
 drivers/staging/android/binder.c | 172 ++++++++++++++++++++++++++++++++-------
 include/linux/ipc_namespace.h    |  29 +++++++
 ipc/namespace.c                  |   9 ++
 ipc/util.c                       |  60 ++++++++++++++
 ipc/util.h                       |   3 +
 6 files changed, 244 insertions(+), 30 deletions(-)

-- 
1.8.3.2

