Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbaK0VhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:37:24 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33756 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaK0VhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:37:22 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/9] staging: panel: Refactor panel initialization
Date: Thu, 27 Nov 2014 22:36:44 +0100
Message-Id: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
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

The whole patchset is already:
Acked-by: Willy Tarreau <w@1wt.eu>

v2: Don't introduce new macros for param value check
v3: Resend, no other changes

Mariusz Gorski (9):
  staging: panel: Set default parport module param value
  staging: panel: Call init function directly
  staging: panel: Remove magic numbers
  staging: panel: Use defined value or checking module params state
  staging: panel: Start making module params read-only
  staging: panel: Make two more module params read-only
  staging: panel: Refactor LCD init code
  staging: panel: Remove more magic number comparison
  staging: panel: Move LCD-related state into struct lcd

 drivers/staging/panel/panel.c | 669 ++++++++++++++++++++++--------------------
 1 file changed, 354 insertions(+), 315 deletions(-)

-- 
2.1.3

