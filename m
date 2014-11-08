Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaKHBlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:41:08 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61996 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaKHBlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:41:06 -0500
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de, tony.luck@intel.com
Cc: ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2]RAS: add the support for handling UCNA/DEFERRED error 
Date: Sat,  8 Nov 2014 09:40:19 +0800
Message-Id: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

At the suggestion of Boris, the first patch extends the mce_severity
mechanism for handling UCNA/DEFERRED error.
  Link: https://lkml.org/lkml/2014/10/23/190

v2:
The first patch have also eliminated a big hack to make mce_severity() 
work when called from non-exception context on the advice of Tony and 
Boris.
  Link: https://lkml.org/lkml/2014/10/27/1017

And on the basis of the first patch, the second patch adds the support
for identifying and handling UCNA/DEFERRED error in machine_check_poll.

V3:
According to Boris, the second patch have also split `memory_error' 
from mem_deferred_error so that the memory_error() function can be used
in other code paths separately. 
  Link: https://lkml.org/lkml/2014/11/6/452

Boris also reported the warning about "MCI_STATUS_POISON" and  "MCI_STATUS_POISON"
redefined.

thx!
cyc

[PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
[PATCH v3 2/2] x86, mce: support memory error recovery for both UCNA
