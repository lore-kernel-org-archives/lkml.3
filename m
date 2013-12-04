Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3LDXMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:12:21 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:45565 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3LDXMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:12:17 -0500
Date: Wed, 4 Dec 2013 18:12:12 -0500
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [3.8-rc3 -> 3.8-rc4 regression] Re: [PATCH] module, async:
 async_synchronize_full() on module init iff async is used
Message-ID: <20131204231212.GB10785@mtj.dyndns.org>
References: <20130116025251.GM2668@htj.dyndns.org>
 <20130812070411.GA2878@elie.Belkin>
 <20130812150900.GJ15892@htj.dyndns.org>
 <CAKA=qzY5NBZSv8r9sHqX-3fY-yrSXq26zPM1AvjoANaZkqJavQ@mail.gmail.com>
 <CA+55aFw9wNBoJBYQ+kjpqs6cnVjGHVs2oxfguMmyYXNPcqqzkQ@mail.gmail.com>
 <CAKA=qzY2JYxbO=0s8_SnUn-8b=1+RqsdAzXQhfHYxo1isv0K-g@mail.gmail.com>
 <20131126222945.GC8588@mtj.dyndns.org>
 <CAKA=qzbyPxU8sBRbYzL61VS6R_o5p+2RdPogJ0nOmQ8NBi2GSA@mail.gmail.com>
 <20131203151953.GK8277@htj.dyndns.org>
 <CAKA=qzbFU_Mwra4z=KENUkJuG-o6y11_2Pc1H159uiWi1ooEaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzbFU_Mwra4z=KENUkJuG-o6y11_2Pc1H159uiWi1ooEaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Josh.

On Wed, Dec 04, 2013 at 05:01:53PM -0600, Josh Hunt wrote:
> So there used to be a call to async_synchronize_full() in
> ata_host_register(), but it was removed by
> f29d3b23238e1955a8094e038c72546e99308e61 as part of some fastboot
> changes. Adding it back (in the attached patch) seems to resolve the
> issue when using the broken initrd. I'm guessing adding it back isn't
> an option, but I wanted to point it out.

The problem is that really isn't the root cause of it.  There's no
real interlocking there and the problem gets hidden just because
things are slower.  Putting ssleep(2) there would work the same, so
the true issue is "the kernel is faster with probing now", which is
somewhat challenging to rectify.  :(

Thanks.

-- 
tejun
