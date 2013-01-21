Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3AUR4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:56:50 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56199 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab3AURyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:54:31 -0500
Subject: [PATCH 0/5] fix illegal use of __pa() in KVM code
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 21 Jan 2013 09:52:44 -0800
Message-Id: <20130121175244.E5839E06@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012117-9360-0000-0000-00000F80127A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes a hard-to-debug early boot hang on 32-bit
NUMA systems.  It adds coverage to the debugging code,
adds some helpers, and eventually fixes the original bug I
was hitting.

[v2]
 * Moved DEBUG_VIRTUAL patch earlier in the series (it has no
   dependencies on anything else and stands on its own.
 * Created page_level_*() helpers to replace a nasty switch()
   at hpa's suggestion
 

