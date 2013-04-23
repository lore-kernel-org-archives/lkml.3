Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3DWPwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:52:30 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43920 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab3DWPw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:52:28 -0400
Date: Tue, 23 Apr 2013 11:52:12 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Laight <David.Laight@aculab.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: Unsigned widening casts of binary "not" operations..
Message-ID: <20130423155212.GI31170@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Laight <David.Laight@aculab.com>,
	Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <CA+55aFwpLu0qNms=hkQr43yqD0K9DgESNm91OEWKT1ZuT8MU6Q@mail.gmail.com>
 <CA+55aFy0jPr5udwJx8cZ-QFs-OgZzQ_NJm_VSj_cS7tsKUn3Kw@mail.gmail.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B71EF@saturn3.aculab.com>
 <CA+55aFwogFL=nm=YHwARcz9OTRBdWEDPG0xcqM-H3k-VZTOZPQ@mail.gmail.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B71F2@saturn3.aculab.com>
 <CA+55aFxvpcF7+dyy5d3+JP4Wfv90zPsRVtEhNG9Pky5gWTm_Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxvpcF7+dyy5d3+JP4Wfv90zPsRVtEhNG9Pky5gWTm_Pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 08:42:49AM -0700, Linus Torvalds wrote:
> The best case is for code that does bitmasking ops like this to avoid
> any casts (implicit or explicit) by just avoiding mixed types. That
> was, to a large degree, my hope for the sparse patch, but it's
> nontrivial. Many types are rather "natural" (ie constants have a
> natural "int" type, sizeof() is size_t, etc) and in other cases you
> want to do the same ops for two different types (with the case that
> caused me to start to look at it being the "align to page boundary"
> for a virtual address vs a PAE phys_addr_t) so you can't really avoid
> mixing things in some circumstances.

Maybe it's worth creating a magic helper function, called something
like mask_out() that handles the casting automatically, and it makes
it clear to a reader what you're trying to do?

   	      	     	  	 	   - Ted
