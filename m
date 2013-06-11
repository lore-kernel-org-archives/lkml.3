Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3FKJJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:09:31 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42305 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3FKJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:09:29 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, juri.lelli@gmail.com
Subject: [PATCH 0/3] ftrace: fix stddev calculation and add a test for it
Date: Tue, 11 Jun 2013 11:08:45 +0200
Message-Id: <1370941728-15456-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While profiling kernel functions via ftrace I noticed values of s^2 that
seemed odd. I implemented a test to verify correctness of averages and
s^2 calculations and proved the latter to be wrong. Then I fixed them up.

The first patch refactors function_stat_show() code a bit in order to be
able to implement the test (second patch). Third patch fixes up s^2
calculation (applying Welford's method).

Juri Lelli (3):
  ftrace: refactor basis statistics calculation code
  ftrace: test basic statistics calculation
  ftrace: fix stddev calculation

 kernel/trace/ftrace.c         |   50 ++++++++++++++--------------
 kernel/trace/trace.h          |   16 +++++++++
 kernel/trace/trace_selftest.c |   72 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 114 insertions(+), 24 deletions(-)

-- 
1.7.9.5

