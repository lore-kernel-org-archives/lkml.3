Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab3CYOro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:47:44 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33904 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab3CYOrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:47:43 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 0/4] pintrcl: restore old state when pinctrl_select_state fails
Date: Mon, 25 Mar 2013 15:47:19 +0100
Message-Id: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there's an error when applying a new state (for example, if a pin is already muxed), old state is not restored.
This patch set corrects this behaviour.
The first patch is just a small typo fix.
The second doesn't introduce any functionnal change, but prepares for the third patch.
The third patch undoes what have been done to enable the new state.
The last patch re-applies the old state.

Richard Genoud (4):
  pinctrl: fix typo in header
  pinctrl: create pinctrl_free_setting function
  pinctrl: disable and free setting in select_state in case of error
  pinctrl: re-enable old state in case of error in pinctrl_select_state

 drivers/pinctrl/core.c |   78 ++++++++++++++++++++++++++++++++++++++----------
 drivers/pinctrl/core.h |    2 +-
 2 files changed, 63 insertions(+), 17 deletions(-)

-- 
1.7.2.5

