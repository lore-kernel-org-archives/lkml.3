Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaDGWJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:09:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59444 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbaDGWJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:09:53 -0400
Message-ID: <5343220A.3060007@zytor.com>
Date: Mon, 07 Apr 2014 15:09:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Adam Williamson <awilliam@redhat.com>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
References: <20140404064120.GB11877@gmail.com>		<tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>		<20140404080006.GB6944@gmail.com>	<533EB5F1.8060002@linux.intel.com>		<20140404151359.GB12370@srcf.ucam.org>	 <20140406184023.1e31412d@alan.etchedpixels.co.uk>	 <53419F84.2090204@zytor.com> <53425B2A.10001@linux.intel.com>	 <53431296.10502@zytor.com> <1396908292.4958.24.camel@adam.happyassassin.net>
In-Reply-To: <1396908292.4958.24.camel@adam.happyassassin.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 03:04 PM, Adam Williamson wrote:
> 
> So if I'm following correctly, we should be able to sort the methods
> into three buckets:
> 
> 1) known to (almost) always be 'safe'
> 2) may cause system freeze if they fail
> 3) definitely cause system freeze if they fail
> 
> We put the methods from bucket 1) first, in whichever order makes the
> most sense. Then we put any methods from bucket 2), in an order derived
> from some kind of likelihood of success / likelihood of hang on fail
> calculation. And at the end we can put precisely *one* method from
> bucket 3, which should obviously be the one most likely to succeed on
> the most systems which haven't already worked with one of the other
> methods. We can't have more than one bucket 3) method, it just doesn't
> make sense.
> 

Nice idea, but wrong.  The problem is that you have to consider the
probability of success vs failure of the type 2 & 3 methods, and what is
a regression or not.

> It sounds like at least TRIPLE and BIOS are 'bucket 3' methods, so it
> seems like we have to pick which of the two we think is most useful, put
> it last, and not have the other one. Of the new methods it sounds like
> EFI is 'bucket 1', BIOS is 'bucket 3', and CF9 is 'bucket 2'.
> 
> so, it sounds like...
> 
> 1) ACPI
> 2) KEYBOARD
> 3) ACPI
> 4) KEYBOARD
> 5) EFI
> possibly 6) CF9
> 7) TRIPLE *or* BIOS
> 
> is what you would say makes sense, right? And really all there is to
> decide is whether to include CF9, and whether to put TRIPLE or BIOS at
> the end?
> 

Yep.  And it has now been shown again that CF9 just isn't safe.  We do
TRIPLE as the ultimate fallback now.

	-hpa

