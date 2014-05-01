Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaEAUjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:39:18 -0400
Received: from imap.thunk.org ([74.207.234.97]:44471 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaEAUjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:39:13 -0400
Date: Thu, 1 May 2014 20:39:10 +0000
From: tytso@mit.edu
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
        Kees Cook <kees@outflux.net>
Subject: Re: random: Providing a seed value to VM guests
Message-ID: <20140501203910.GB25829@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andy Lutomirski <luto@amacapital.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
	Kees Cook <kees@outflux.net>
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com>
 <20140501192618.GA25829@thunk.org>
 <CALCETrX=0uA6CCg4UeeV8KgGAq6fxUSiGOw5Gzte4OSHrDWMqA@mail.gmail.com>
 <900441a0-24e8-4976-ad35-3971805b9f34@email.android.com>
 <CALCETrV1HUA-JRAj9UicD3woqec7mSJLoT9CkQq=dOCpdPg4hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV1HUA-JRAj9UicD3woqec7mSJLoT9CkQq=dOCpdPg4hw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 01:32:55PM -0700, Andy Lutomirski wrote:
> On Thu, May 1, 2014 at 1:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > RDSEED is not synchronous.  It is, however, nonblocking.
> 
> What I mean is: IIUC it's reasonable to call RDSEED a few times in a
> loop and hope it works.  It makes no sense to do that with
> /dev/random.

RDSEED is allowed to return an error if there is insufficient entropy.
So long as the caller understands that this is an emulated
instruction, I don't see a problem.

						- Ted
