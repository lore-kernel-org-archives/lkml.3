Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaJTIKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:10:17 -0400
Received: from down.free-electrons.com ([37.187.137.238]:47633 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752949AbaJTIKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:10:14 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: linus.walleij@linaro.org, sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] pinctrl: add helpers for group based drivers
Date: Mon, 20 Oct 2014 10:04:16 +0200
Message-Id: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Sebastian,

As discussed earlier this year[1], this series introduce helpers for group based
pinctrl drivers:
- of_pinctrl_utils_read_function(): reads the function name of a
  specified node, and gets the number of groups it should be
  applied to.
- of_pinctrl_for_each_function_group(): navigates through the groups of
  a specified node, reading at each iteration the name of the current
  group.

A generic function to parse nodes for group based drivers is also added, and
then used in the Berlin pinctrl driver:
- pinconf_generic_function_groups_dt_node_to_map()

[1] https://lkml.org/lkml/2014/5/17/38


Antoine Tenart (4):
  Documentation: bindings: pinctrl: document the generic groups property
  pinctrl: add helpers for group based drivers
  pinctrl: add a generic way to map node to map for group based drivers
  pinctrl: berlin: use the generic node to map function

 .../bindings/pinctrl/pinctrl-bindings.txt          |  1 +
 drivers/pinctrl/berlin/Kconfig                     |  1 +
 drivers/pinctrl/berlin/berlin.c                    | 53 +---------------------
 drivers/pinctrl/pinconf-generic.c                  | 36 +++++++++++++++
 drivers/pinctrl/pinctrl-utils.c                    | 26 +++++++++++
 drivers/pinctrl/pinctrl-utils.h                    |  9 ++++
 include/linux/pinctrl/pinconf-generic.h            |  3 ++
 7 files changed, 78 insertions(+), 51 deletions(-)

-- 
1.9.1

