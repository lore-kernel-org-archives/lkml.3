Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3KPIYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 03:24:39 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33335 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3KPIYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 03:24:33 -0500
From: "Du, Changbin" <changbin.du@gmail.com>
To: jbaron@akamai.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
        akpm@linux-foundation.org, "Du, Changbin" <changbin.du@gmail.com>
Subject: [PATCH v5 0/3] add wildcard support for dynamic debug
Date: Sat, 16 Nov 2013 16:24:06 +0800
Message-Id: <1384590249-16672-1-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <CABgQ-Th3arUm=rLcv4FGRamAN00kGnDsO_VsHkRp4ZfFGOjaZQ@mail.gmail.com>
References: <CABgQ-Th3arUm=rLcv4FGRamAN00kGnDsO_VsHkRp4ZfFGOjaZQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Changbin" <changbin.du@gmail.com>

These patches are to make it easier to filter kernel debug logs which
we want.
Whith wildcard support, below command can enable all usb debug logs:
    #echo "file drivers/usb/* +p" > <debugfs>/dynamic_debug/control
This patch only enables two wildcard:
    '*' - matches zero or more characters
    '?' - matches one character

Changes since v4:
    moved matching function to lib/parser.c

Du, Changbin (3):
  lib/parser.c: add match_wildcard function
  dynamic_debug: add wildcard support to filter files/functions/modules
  dynamic-debug-howto.txt: update since new wildcard support

 Documentation/dynamic-debug-howto.txt |  9 +++++++
 include/linux/parser.h                |  1 +
 lib/dynamic_debug.c                   | 15 +++++++----
 lib/parser.c                          | 51 +++++++++++++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 5 deletions(-)

-- 
1.8.3.2

