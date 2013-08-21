Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3HUOzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:55:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3HUOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:55:03 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=roXeUe4e85gA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JzSCUfRX3cwA:10 a=xGjK5tjtlBCli4ZjzaoA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 21 Aug 2013 10:54:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821105459.0b392711@gandalf.local.home>
In-Reply-To: <20130821141725.GB20685@1wt.eu>
References: <20130820224032.GA20491@kroah.com>
	<CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
	<20130820235700.GA7209@kroah.com>
	<CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
	<20130821134248.GB16493@home.goodmis.org>
	<20130821141725.GB20685@1wt.eu>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 16:17:25 +0200
Willy Tarreau <w@1wt.eu> wrote:

> This is also what I suspected though I have no data to confirm or deny that.
> If this happens to be the case, maybe then there should be some barrier such
> as :
>   - everything merged at -rc4 or before gets backported after the next -rc
>   - everything from -rc5 and upper waits for next -rc1 unless tagged urgent ?

No, I think a full -rc cycle would be good. All commits tagged for
stable that appeared in -rc4 (added from -rc3), must wait till -rc5
before it is added to stable. That way we have a week of full exposure
to find problems.

I guess the other question to ask is, how long does it take for a
problem to appear after hitting mainline? If a problem is found in -rc4
before -rc5 comes out, then this would be sufficient. But if the
problem from -rc4 isn't found till -rc6 then that tells us something
too.

We should be using pass data to determine these heuristics. But I don't
have that data, but Greg should.


-- Steve
