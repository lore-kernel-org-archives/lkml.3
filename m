Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150Ab3EFXfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758156Ab3EFXfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:35:20 -0400
Message-ID: <1367883316.22645.2.camel@dcbw.foobar.com>
Subject: Re: [GIT] Networking
From: Dan Williams <dcbw@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, hayeswang <hayeswang@realtek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 06 May 2013 18:35:16 -0500
In-Reply-To: <1367526148.7757.30.camel@dcbw.foobar.com>
References: <20130501.164755.1859264969403837546.davem@davemloft.net>
	 <CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
	 <1367512467.4000.7.camel@dcbw.foobar.com>
	 <1367519066.7757.19.camel@dcbw.foobar.com>
	 <CA+55aFy04mY5g-Aics9dcGpv6zgn2bu4iQ-_ifE5hun_t4E54Q@mail.gmail.com>
	 <CA+55aFy1P6TKZjWSvrJN6o=gAr7OTYQsoZORXGF6g8OnonBT=Q@mail.gmail.com>
	 <1367522254.7757.23.camel@dcbw.foobar.com>
	 <1367526148.7757.30.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 15:22 -0500, Dan Williams wrote:
> On Thu, 2013-05-02 at 14:17 -0500, Dan Williams wrote:
> > On Thu, 2013-05-02 at 11:53 -0700, Linus Torvalds wrote:
> > > On Thu, May 2, 2013 at 11:52 AM, Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > but for some reason in the bad case NM just doesn't react past the
> > > > "carrier now ON" part.
> > > 
> > > Grr. That was much more readable while editing, then gmail ended up
> > > doing its "smart line wrap" thing and my nice long lines became a
> > > mess. I think you can still figure it out,
> > 
> > Yeah, the dump is good, and it seems to point to a problem in NM for
> > now.  I'm investigating.
> 
> If you don't mind helping me confirm/reject a theory, would you mind:
> 
> 1) drop "level=debug" into the [logging] section
> of /etc/NetworkManager/NetworkManager.conf (create the section if it
> doesn't exist)
> 
> 2) reboot (or just rmmod/modprobe r8169 if that's enough to trigger it)
> 
> 3) grab syslog and send it to me (privately if you wish)

Spent a while trying to reproduce this on a tg3 today, twiddling the
carrier from the code, but failed to do so...  if you're at all able to
get the debug logs here as mentioned here, that would help greatly.

Contrary to the suggestion above, changing the log level in
NetworkManager.conf does not immediately start logging in that level,
you do need to restart NM.  So with that in mind, I'd suggest a full
reboot of the system just to make sure we have the exact same situation
as when you experience the problem.

(I'm still mystified how the netdev features thing "fixes" this
though...)

Thanks!
Dan

