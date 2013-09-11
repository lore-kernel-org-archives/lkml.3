Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab3IKU24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:28:56 -0400
Received: from imap.thunk.org ([74.207.234.97]:58511 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab3IKU2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:28:55 -0400
Date: Wed, 11 Sep 2013 16:28:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Jeff Garzik <jgarzik@pobox.com>,
        David Safford <safford@us.ibm.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Subject: Re: TPMs and random numbers
Message-ID: <20130911202831.GC13397@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Jeff Garzik <jgarzik@pobox.com>, David Safford <safford@us.ibm.com>,
	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
	Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
	Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	David Safford <safford@watson.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>,
	"Johnston, DJ" <dj.johnston@intel.com>
References: <1378920168.26698.64.camel@localhost>
 <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
 <20130911184509.GB13397@thunk.org>
 <CAFtxgO7XKbNn1-VW6Ha9P9wj7VAHw6Upar9udgy6dMrFNAHU0Q@mail.gmail.com>
 <CALCETrX0hN5hfW0rAsJ-uAKyV5eVSdhntT0TOVumLm2CDyLLBQ@mail.gmail.com>
 <41ba2dff-12ed-4127-acbd-ae5b40e38afd@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41ba2dff-12ed-4127-acbd-ae5b40e38afd@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 12:25:48PM -0700, H. Peter Anvin wrote:
> This of course has been a long-running debate.  Similarly, we could
> make much better use of RDRAND if instead of doing data reduction in
> rngd we could feed it to the pool and just credit fractional bits.
> The FIPS tests that rngd runs are weak and obsoleted, but perhaps
> better than nothing (now when we don't shut down rngd due to false
> positives.)

/dev/urandom is using RDRAND already, and that's what most of the
applications which are generating ssh host keys, session keys, etc.,
are using.

/dev/random is using RDRAND as well, but we're not giving any entropy
credit, so it will take longer to get the necessary randomness to
generate a GPG key.

The rason why it would be good to use TPM to fetch randomness is for
those platforms is (a) for pre-RDRAND capable x86 systems, and (c)
non-x86 platforms that might be using a TPM which don't have a RDRAND
function.

Also, in general, it's better to use as many entropy sources as
possible.

Cheers,

					- Ted
