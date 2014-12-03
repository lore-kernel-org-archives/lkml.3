Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaLCOJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:09:17 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:51164 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaLCOI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:08:57 -0500
Date: Wed, 3 Dec 2014 14:42:26 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Lars Persson <lars.persson@axis.com>
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "paul.burton@imgtec.com" <paul.burton@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "manuel.lauss@gmail.com" <manuel.lauss@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "blogic@openwrt.org" <blogic@openwrt.org>,
        "markos.chandras@imgtec.com" <markos.chandras@imgtec.com>
Subject: Re: [PATCH] Revert "MIPS: Remove race window in page fault handling"
Message-ID: <20141203134226.GC16063@linux-mips.org>
References: <20141203032542.15388.17340.stgit@linux-yegoshin>
 <1417599104.10996.16.camel@lnxlarper.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417599104.10996.16.camel@lnxlarper.se.axis.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars,

normally set_pte_at() is invoked in a 

  cache_flush_*()
  set_pte_at()
  tlb_flush_*()

sequence.  So I'm wondering if you're trying to fix something in set_pte_at
that actually ought to be fixed in the cache_flush_*() function.

I'm wondering, have you identified which cache flush function in particular
was used in the sequence in your particular bug's case?

  Ralf
