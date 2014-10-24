Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaJXWbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:31:21 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:46797 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbaJXWbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:31:19 -0400
Date: Fri, 24 Oct 2014 17:29:09 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/7] staging: skein: CryptoAPI and Module Support
Message-ID: <cover.1414189566.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds CryptoAPI and loadable module support to the Skein Hashing
Algorithm. Collapses threefish module into skein module. Renames skein.c
and skein.h to skein_base.c and skein_base.h so module can be named
skein.ko. Inlines rotl_64 macro. Removes unneeded #define and
skein_debug.h include.

Eric Rost (7):
  staging: skein: Collapses threefish module
  staging: skein: Renames skein to skein_base
  staging: skein: Adds CryptoAPI Support
  staging: skein: Adds Loadable Module Support
  staging: skein: Inlines rotl_64
  staging: skein: Removes unneeded #define
  staging: skein: Removes skein_debug include

 drivers/staging/skein/Kconfig                   |  24 +--
 drivers/staging/skein/Makefile                  |  13 +-
 drivers/staging/skein/skein_api.h               |   2 +-
 drivers/staging/skein/{skein.c => skein_base.c} |   5 +-
 drivers/staging/skein/{skein.h => skein_base.h} |  31 ++--
 drivers/staging/skein/skein_block.c             |   2 +-
 drivers/staging/skein/skein_block.h             |   2 +-
 drivers/staging/skein/skein_generic.c           | 216 ++++++++++++++++++++++++
 drivers/staging/skein/skein_iv.h                |   2 +-
 drivers/staging/skein/threefish_api.h           |   2 +-
 10 files changed, 249 insertions(+), 50 deletions(-)
 rename drivers/staging/skein/{skein.c => skein_base.c} (99%)
 rename drivers/staging/skein/{skein.h => skein_base.h} (95%)
 create mode 100644 drivers/staging/skein/skein_generic.c

-- 
2.1.1

