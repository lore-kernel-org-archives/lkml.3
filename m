Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbbANARU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:17:20 -0500
Received: from vapor.isi.edu ([128.9.64.64]:57890 "EHLO vapor.isi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbbANART (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:17:19 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 19:17:19 EST
Date: Tue, 13 Jan 2015 16:10:57 -0800
From: Craig Milo Rogers <rogers@isi.edu>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Linux MM <linux-mm@kvack.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Andreas Mohr <andi@lisas.de>,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] kstrdup optimization
Message-ID: <20150114001057.GA30408@isi.edu>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com> <CAMuHMdV74n3v81xaLRDN_Mn_QGg14yUkXNn6JYaGH4MGgLRM2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV74n3v81xaLRDN_Mn_QGg14yUkXNn6JYaGH4MGgLRM2A@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ISI-4-43-8-MailScanner: Found to be clean
X-MailScanner-From: rogers@jib.isi.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As kfree_const() has the exact same signature as kfree(), the risk of
> accidentally passing pointers returned from kstrdup_const() to kfree() seems
> high, which may lead to memory corruption if the pointer doesn't point to
> allocated memory.
...
>> To verify if the source is in .rodata function checks if the address is between
>> sentinels __start_rodata, __end_rodata. I guess it should work with all
>> architectures.

	kfree() could also check if the region being freed is in .rodata, and
ignore the call; kfree_const() would not be needed.  If making this check all
the time leads to a significant decrease in performance (numbers needed here),
another option is to keep kfree_const() but add a check to kfree(), when
compiled for debugging, that issues a suitable complaint if the region being
freed is in .rodata.

					Craig Milo Rogers
