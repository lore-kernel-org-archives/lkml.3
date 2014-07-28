Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaG1N7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:59:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33590 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaG1N7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:59:36 -0400
Date: Mon, 28 Jul 2014 15:59:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140728135933.GA5918@pd.tnic>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721160346.GP30979@8bytes.org>
 <20140721230500.GA7019@amd.pavel.ucw.cz>
 <6793803.1FXN0a3O0V@vostro.rjw.lan>
 <20140722103443.GV30979@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140722103443.GV30979@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 12:34:44PM +0200, Joerg Roedel wrote:
> So my test was to resume from a swap partition that contained no image.
> Here is the result from the 16GB machine. First with a v3.16-rc6 kernel
> without my changes:
> 
> kv:~/base # time perf record /usr/sbin/resume /dev/sda1
> resume: libgcrypt version: 1.5.3
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.019 MB perf.data (~823 samples) ]
> 
> real    0m0.084s
> user    0m0.012s
> sys     0m0.064s
> 
> Here is the result with my patches on top:
> 
> kv:~/hibernate # time perf record /usr/sbin/resume /dev/sda1
> resume: libgcrypt version: 1.5.3
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.014 MB perf.data (~602 samples) ]
> 
> real    0m0.032s
> user    0m0.003s
> sys     0m0.027s
> 
> So we save around 50ms (or 62% of time) already on this 16GB machine.

So, let's see, with Joerg's patches we

- solve the issue on huge boxes. And yes, we most definitely want to be
able to suspend them too. RAS is one very prominent use case here.

*and*

- we see improvement on smaller boxes, above numbers look good to me.

and all that for an additional 8K for a S/R cycle?! And for some
additional complexity of a radix tree which is self-contained, well
tested and understood?

This looks like certainly like net win to me.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
