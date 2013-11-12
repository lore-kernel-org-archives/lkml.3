Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3KLLXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 06:23:46 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:57393 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3KLLXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:23:43 -0500
Date: Tue, 12 Nov 2013 12:23:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/boot changes for v3.13
Message-ID: <20131112112338.GA12801@gmail.com>
References: <20131111170558.GA12741@gmail.com>
 <CAE9FiQWrzZB+wpSXGeQTPKi2o7MKvONFkk0_POe-E+wco07Erw@mail.gmail.com>
 <20131112103422.GA12849@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112103422.GA12849@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Nov 11, 2013 at 01:37:48PM -0800, Yinghai Lu wrote:
> > How do you know CPU0 and CPU1 are in same package?
> 
> Why is that relevant?

So I suspect what Yinghai tried to say if CPU0 and CPU1 are not on the 
same node we do the printout incorrectly.

Arguably this was a pre-existing condition, but would be nice to fix it 
now that this code has emerged out of steady bitrot! :-)

How difficult would it be in your opinion? I think the best way to go 
about it would be to include CPU#0 in the list - I don't think anyone will 
be confused by the fact that it has already booted. That way the 'gap' for 
CPU#0 would be eliminated. Or something like that.

Btw., while staring at that code once more I noticed the following small 
nit, there's a pre-existing weird way of writing the -1 literal:

                          if (current_node > (-1))

Thanks,

	Ingo
