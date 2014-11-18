Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbaKRU7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:59:06 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42776 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaKRU7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:59:03 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] staging: panel: Refactor panel initialization
Date: Tue, 18 Nov 2014 21:56:05 +0100
Message-Id: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches focuses on making current initialization
process easier to understand - especially it tries to emphasize
what are the priorities of the params coming from different
sources (Kconfig values, device profiles and module param values
set on loading). I paid attention not to change to behaviour of
the code itself (at least for now), so all hacky places are kept.

Mariusz Gorski (9):
  staging: panel: Set default parport module param value
  staging: panel: Call init function directly
  staging: panel: Remove magic numbers
  staging: panel: Use a macro for checking module params state
  staging: panel: Start making module params read-only
  staging: panel: Make two more module params read-only
  staging: panel: Refactor LCD init code
  staging: panel: Remove more magic number comparison
  staging: panel: Move LCD-related state into struct lcd

 drivers/staging/panel/panel.c | 672 ++++++++++++++++++++++--------------------
 1 file changed, 357 insertions(+), 315 deletions(-)

-- 
2.1.3

