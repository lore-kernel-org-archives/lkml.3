Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001AbaKUQlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:41:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46595 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758982AbaKUQlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:41:42 -0500
Date: Fri, 21 Nov 2014 17:41:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: rui wang <ruiv.wang@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Message-ID: <20141121164140.GA4274@pd.tnic>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
 <20141119102954.GA5617@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
 <20141120101505.GA791@pd.tnic>
 <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:20:59AM +0800, rui wang wrote:
> We've found there are cases after mce_log() has been called, we then
> decide to panic, but print_mce() can't find anything in the mcelog
> buffer. I think the mcelog buffer can be consumed by the user space
> daemon (possibly on a different CPU). We may end up seeing the "panic
> from unknown source" message without printing any mca banks, which is
> one of the cases where this bug was originated.

Ok, so modify the mcelog buffer to not zero out its entries when they're
being read out in userspace through mce_chrdev_read() but simply to
leave them in. Then you can read them out again on panic time. The mce
log buffer will have to become a circular buffer or something like that.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
