Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaIASr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:47:57 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40319 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaIASr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:47:56 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: patches@linaro.org, Mike Turquette <mturquette@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH 0/3] arm: kirkwood: model cpu clock mux and update cpufreq driver
Date: Mon,  1 Sep 2014 11:47:02 -0700
Message-Id: <1409597225-24368-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reviewing Tomeu's "Per-user clock constraints" series I saw that
the Kirkwood cpufreq driver needed to use a new, public clk_is_enabled()
which I hoped not to merge [0].

This led to some investigation as to why this was needed and with
Andrew's help I came to realize that the powersave_clk on the kirkwood
platform acts more like a clock signal multiplexer than a gate. This mux
is unique to Kirkwood; none of the other mvebu platforms have it.

This series updates the kirkwood clock driver to model the powersave_clk
as a mux instead of a gate, and it updates and slightly simplifies the
cpufreq driver to use this clock as a mux.

Rafael & Viresh: I'd prefer to merge the cpufreq driver patch through
the clock tree since Tomeu's changes to the clock core depend on it.

[0] http://lkml.kernel.org/r/CAPtuhThyUPrY2AqVEsyRQqR-8hsj_GAe1W0u_XXonP-C2o_Xew@mail.gmail.com

Mike Turquette (3):
  clk: mvebu: share locks between gate clocks
  clk: mvebu: powersave clock is a multiplexer
  cpufreq: kirkwood: use the powersave multiplexer

 drivers/clk/mvebu/common.c         |   9 ++--
 drivers/clk/mvebu/common.h         |   2 +
 drivers/clk/mvebu/kirkwood.c       | 102 ++++++++++++++++++++++++++++++++++++-
 drivers/cpufreq/kirkwood-cpufreq.c |  14 ++---
 4 files changed, 113 insertions(+), 14 deletions(-)

-- 
1.8.3.2

