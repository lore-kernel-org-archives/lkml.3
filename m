Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3CEWPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:15:40 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38751 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab3CEWPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:15:38 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: konrad.wilk@oracle.com, jwboyer@redhat.com,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 0/2] v3.9-rc1 fixes for intel_pstate driver
Date: Tue,  5 Mar 2013 14:15:25 -0800
Message-Id: <1362521727-20666-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

These patches fix the issues reported against the intel_pstate driver.

The first bug reported by Josh Boyer was that the dirver would blow up
when loading in a VM exposed the second bug that the error path in
intel_pstate_init() was incorrect and biting Konrad Wilk as well.

https://bugzilla.redhat.com/show_bug.cgi?id=916833
https://lkml.org/lkml/2013/3/5/394

Dirk Brandewie (2):
  cpufreq/intel_pstate: Do not load on VM that do not report max P
    state.
  cpufreq/intel_pstate: Fix intel_pstate_init() error path

 drivers/cpufreq/intel_pstate.c |   42 +++++++++++++--------------------------
 1 files changed, 14 insertions(+), 28 deletions(-)

-- 
1.7.7.6

