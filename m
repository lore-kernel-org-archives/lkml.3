Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaFEWoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:44:39 -0400
Received: from mxip4-inbound.gatech.edu ([130.207.182.13]:21058 "EHLO
	mxip4-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaFEWoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:44:38 -0400
X-RemoteIP: 130.207.185.161
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 89278155
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.98,984,1392181200"; 
   d="scan'208";a="89278155"
X-GT-Spam-Rating: (0%)
Message-ID: <5390F2D5.909@gatech.edu>
Date: Thu, 05 Jun 2014 18:44:37 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: peterz@infradead.org, mingo@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: regarding use of various cmpxchg* API
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, Ingo,

I see that in the drivers there are the following types of cmpxchg API:

__cmpxchg64()
atomic_cmpxchg()
atomic64_cmpxchg()
cmpxchg()
atomic_long_cmpxchg()
cmpxchg_local()
local_cmpxchg()(in kernel/events/ring_buffer.c)
this_cpu_cmpxchg()

Since cmpxchg() internally handles the width, do you think it makes sense to replace the above uses of cmpxchg with the document API (cmpxchg, atomic_cmpxchg, cmpxchg_local)?

I am willing to do this and wanted to know if it something you think is worth pursuing.

Regards,
Pranith
