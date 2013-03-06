Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3CFIDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:03:44 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:46595 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab3CFIDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:03:43 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvNtABT3NlFV5qjOPGdsb2JhbABEh3uFILdoAwGBbRcDAQEBATg0gioBAQQBOhwjBQsIAxQNJQ8FJQoaE4gNCrtaFY0sS4EBB4JfYQOWSYYHjXE
X-IronPort-AV: E=Sophos;i="4.84,793,1355094000"; 
   d="scan'208";a="508302064"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Mar 2013 09:06:42 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
Message-ID: <20130306080642.GA535@polaris.bitmath.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Peter,

> I don't know if it's just me, but this merge window had more "Uhhuh"
> moments than I'm used to. I stopped merging a couple of times, because
> we had bugs that looked really scary, but thankfully each time people
> were on them like paparazzi on Justin Bieber. Special thanks to Peter,
> Ted and Rafael (and the people who reported the bugs too!) for being
> so responsive. It could have been so much worse.

Or not. ;-) This commit breaks boot on my MacBookAir3,1:

commit 8d57470d8f859635deffe3919d7d4867b488b85a
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Nov 16 19:38:58 2012 -0800

    x86, mm: setup page table in top-down
    
    Get pgt_buf early from BRK, and use it to map PMD_SIZE from top at first.
    Then use mapped pages to map more ranges below, and keep looping until
    all pages get mapped.

Being a 64-bit apple-EFI machine, it probably runs through an obscure
path in this patch. I wish I had more vital information, but I get the
white screen of death, so not much to go on so far.

Henrik
