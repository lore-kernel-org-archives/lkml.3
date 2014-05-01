Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaEAW2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:28:37 -0400
Received: from imap.thunk.org ([74.207.234.97]:44680 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaEAW2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:28:35 -0400
Date: Thu, 1 May 2014 22:28:32 +0000
From: tytso@mit.edu
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
        Kees Cook <kees@outflux.net>
Subject: Re: random: Providing a seed value to VM guests
Message-ID: <20140501222832.GD25829@thunk.org>
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
 <20140501203910.GB25829@thunk.org>
 <CALCETrUr7NXkkN27v2Uf-puEtSXbgp=E+99aC_SdTc6puR8+CA@mail.gmail.com>
 <5362B618.50602@zytor.com>
 <CALCETrXu_bFjemS3TZNDDes=cBgkUXtDH-6cA84JcNjD0AdZ7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXu_bFjemS3TZNDDes=cBgkUXtDH-6cA84JcNjD0AdZ7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 02:06:13PM -0700, Andy Lutomirski wrote:
> 
> I still don't see the point.  What does this do better than virtio-rng?

I believe you had been complaining about how complicated it was to set
up virtio?  And this complexity is also an issue if we want to use it
to initialize the RNG used for the kernel text ASLR --- which has to
be done very early in the boot process, and where making something as
simple as possible is a Good Thing.

And since we would want to use RDRAND/RDSEED if it is available
*anyway*, perhaps in combination with other things, why not use the
RDRAND/RDSEED interface?

							- Ted
