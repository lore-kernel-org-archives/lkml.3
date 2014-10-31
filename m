Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbaJaBZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:25:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42559 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369AbaJaBZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:25:40 -0400
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, ak@linux.intel.com, gong.chen@linux.intel.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mce-inject: extend mce-inject for support threshold interrupt event injection on ADM platform
Date: Fri, 31 Oct 2014 09:24:05 +0800
Message-Id: <1414718648-7766-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The work based on Boris's ras-for-3.19 branch.
https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git -b ras-for-3.19

Until now, `mce-inject' is unable to inject threshold interrupt event 
on AMD platform. That's because both Threshold Interrupt and POLL have a
separate event handler. amd_threshold_interrupt() is used for handling
Threshold Interrupt event. And machine_check_poll() has been used for
polling other events, such as `deferred' error. The main items of this
work include:

  * apply MCE MSR wrappers to AMD-specific threshold interrupt handler 
    for supporting mce-inject
  * introduces a new flag MCJ_INTERRUPT that is used to separate 
    CMCI/Threshold Interrupt and POLL in mce-inject.

Note that Linux machine check injector tool - mce-inject should be also
updated for accommodating the above changes in kernel-space.
  * [PATCH] separate CMCI/Threshold Interrupt and POLL in mce-inject
  * https://git.kernel.org/pub/scm/utils/cpu/mce/mce-inject.git
