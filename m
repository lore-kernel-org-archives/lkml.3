Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbaGRHOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:14:50 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:58385 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaGRHOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:14:47 -0400
From: matwey@sai.msu.ru
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        hsommer@eso.org, gnomes@lxorguk.ukuu.org.uk, matwey.kornilov@gmail.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCHv4 0/2] parport: parport_pc: Fix false-positives at checking for Intel bug
Date: Fri, 18 Jul 2014 11:12:53 +0400
Message-Id: <1405667575-3291-1-git-send-email-matwey@sai.msu.ru>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>

Hi,

The following patch series is to deal with the issue on false-positives
of Intel EPP bug check [1].

More than a decade ago, the check was introduced in order to prevent EPP
operation on the some Intel LPT chipsets. The main issue to defence from
was CPU hang at EPP operation on broken chipsets. It is mentioned that
affected chipsets are Intel 82091. However, it is not known whether
there are others.

The check was implemented in strange manner. Now, there is no explanations
why. The check itself now leads to the false-positives, disabling EPP on
many PC-s (Dell OptiPlex series for instance). The latter is an issue.

As it was suggested by One Thousand Gnomes we implement the additional check of CPU model.
If CPU is Intel 80486 or Pentium, then it is considered as potentially affected by the initial problem, so the initial check is applied.

The patches organized as following:

1. Introduce-intel_bug_present-function.

The transparent refactoring of the check is performed.
Make the check be immutable regarding to ECR register.

2. Implement CPU model check to cut off false-positives

Based on CPU model, disable the check. The check is enabled only for Intel 80486 or Pentium.

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=630593

Suggested-by: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> 
Tested-by: Heiko Andreas Sommer <hsommer@eso.org>
Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>

---
Changes from v3:
 - Do not introduce the additional option, rely on CPU model instead.

Changes from v2:
 - The module option has more clear description

Changes from v1:
 - Patch 1 fetched from right branch and now compiled

