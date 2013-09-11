Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3IKSqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:46:00 -0400
Received: from imap.thunk.org ([74.207.234.97]:58442 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab3IKSp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:45:59 -0400
Date: Wed, 11 Sep 2013 14:45:09 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Safford <safford@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Subject: Re: TPMs and random numbers
Message-ID: <20130911184509.GB13397@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	David Safford <safford@us.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
	Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
	Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	David Safford <safford@watson.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>,
	"Johnston, DJ" <dj.johnston@intel.com>
References: <1378920168.26698.64.camel@localhost>
 <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:49:59AM -0700, Andy Lutomirski wrote:
> 
> A TPM that has an excellent internal entropy source and is FIPS 140-2
> compliant with no bugs whatsoever may still use Dual_EC_DRBG, which
> looks increasingly likely to be actively malicious.

To be fair, given the limited CPU found in most TPM's, using
Dual_EC_DRBG would be rather unlikely.  It's more likely that the TPM
would be using a real hardware RNG --- and if the TPM was compromised
by some evil spy agency, it would be doing using something like
AES_ENCRYPT(i++, NSA_KEY), not using Dual_EC_DRBG.

> I'd be *much* happier if my system read a few hundred random bytes
> from the TPM at startup and fed those bytes into the kernel's entropy
> pool.  This should IMO happen at startup as early as possible.

We should definitely do this.  If the TPM driver could fetch some
randomness and then call add_device_randomness() to feed this into the
random driver's entropy pool when it initializes itself, that would be
***really*** cool.

							- Ted
