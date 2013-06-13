Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3FMDor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:44:47 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60228 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab3FMDoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:44:46 -0400
Message-ID: <51B9402C.5070300@gmail.com>
Date: Wed, 12 Jun 2013 22:44:44 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] pstore/ram for 3.11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure who takes this, but please pull these 2 changes for pstore for
3.11. These are necessary to get pstore to work with on-chip RAM on
Calxeda highbank platform.

I dropped the write-combine change from this series. While write-combine
is technically the correct mapping needed for ARM, it doesn't solve any
problem for me.

Rob

The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:

  Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:

  git://sources.calxeda.com/kernel/linux.git tags/pstore-for-3.11

for you to fetch changes up to da98a8882b3b388e9580821c8ad281c85f94d025:

  pstore/ram: avoid atomic accesses for ioremapped regions (2013-05-21
15:32:44 -0500)

----------------------------------------------------------------
2 changes for pstore ram:

- Don't use atomic ops on ioremapped RAM which is not supported on ARM
- Allow non-power of 2 sized RAM buffers

----------------------------------------------------------------
Rob Herring (2):
      pstore/ram: remove the power of buffer size limitation
      pstore/ram: avoid atomic accesses for ioremapped regions

 fs/pstore/ram.c      |  2 --
 fs/pstore/ram_core.c | 54
++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 52 insertions(+), 4 deletions(-)
