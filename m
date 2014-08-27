Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaH0IJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:09:25 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:34102 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaH0IJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:09:21 -0400
From: matwey@sai.msu.ru
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        hsommer@eso.org, matwey.kornilov@gmail.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCHv5 0/2] parport: parport_pc: Fix false-positives at checking for Intel bug
Date: Wed, 27 Aug 2014 12:07:42 +0400
Message-Id: <1409126864-2615-1-git-send-email-matwey@sai.msu.ru>
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

Here is new version of the patches supposed to shrink the set of the false-positives.
We know that the initial problem arises on x86 with motherboard LPT controller.
The patches following are to enable initial check only for x86 and non-PCI based devices.
It is hard to correctly determine which CPUs could be installed into PentiumPro-compatible
socket, so I postponed initial Alan's suggestion.

For those who want to check theirs hardware, there's prebuilt usb-stick image available:
https://susestudio.com/a/OdbKqm/opensuse-13-1-parport_pc

The patches organized as following:

1. Introduce-intel_bug_present-function

The transparent refactoring of the check is performed.
Make the check be immutable regarding to ECR register.

2. Implement architecture and device check to cut off false-positives

Run the initial check only for x86, and for 'legacy' devices.


[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=630593

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>

---
Changes from v4:
 - Revert to v1 and implement different checks: arch and PCI-based.

Changes from v3:
 - Do not introduce the additional option, rely on CPU model instead.

Changes from v2:
 - The module option has more clear description

Changes from v1:
 - Patch 1 fetched from right branch and now compiled

