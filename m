Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3AVVZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:25:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60495 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3AVVZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:25:04 -0500
Subject: [PATCH 0/5] [v3] fix illegal use of __pa() in KVM code
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 22 Jan 2013 13:24:28 -0800
Message-Id: <20130122212428.8DF70119@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012221-2398-0000-0000-0000104E05BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes a hard-to-debug early boot hang on 32-bit
NUMA systems.  It adds coverage to the debugging code,
adds some helpers, and eventually fixes the original bug I
was hitting.

[v3]
 * Remove unnecessary initializations in slow_virt_to_phys(),
   and convert 'level' to use the new enum pg_level.
 * Add some text to slow_virt_to_phys() to make it clear
   that we are not using it in any remotely fast paths.
[v2]
 * Moved DEBUG_VIRTUAL patch earlier in the series (it has no
   dependencies on anything else and stands on its own.
 * Created page_level_*() helpers to replace a nasty switch()
   at hpa's suggestion
 

