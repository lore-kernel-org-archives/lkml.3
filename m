Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3KRAmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 19:42:19 -0500
Received: from chicago.guarana.org ([192.210.136.102]:44209 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab3KRAmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 19:42:12 -0500
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Nov 2013 19:42:12 EST
Date: Mon, 18 Nov 2013 11:33:25 +1100
From: Kevin Easton <kevin@guarana.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Francis Moreau <francis.moro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131118003325.GA25843@chicago.guarana.org>
References: <52888F6D.6000802@gmail.com>
 <20131117132531.GB27696@pd.tnic>
 <5288E5BF.2020608@gmail.com>
 <20131117160126.GG27323@pd.tnic>
 <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
 <20131117195358.GO27323@pd.tnic>
 <20131117220611.GQ27323@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131117220611.GQ27323@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 11:06:12PM +0100, Borislav Petkov wrote:
> and the virtual address in rIP is ffffffff8106f5c3, i.e. the same one
> as in the photo. Thus, the CALL instruction tries to call the timer
> function 'fn' which we pass as an argument to call_timer_fn.
> 
> However, the address we're trying to call in %r14 is garbage:
> 0x455300323d504544 and not in canonical form, causing the #GP.

That's part of an ASCII string, "DEP=2\0SE", so if that looks familiar
to anyone (part of a kernel command line?) it might give a clue to
where the timer callback pointer is being overwritten.

> So basically what happens is suspend to RAM corrupts something
> containing one or more timer functions and we end up calling crap after
> resume.

    - Kevin
