Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3EUTCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 15:02:03 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:50400 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab3EUTB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 15:01:59 -0400
Date: Tue, 21 May 2013 15:01:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH][RFC] CPU Jitter random number generator (resent)
Message-ID: <20130521190157.GD22559@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
References: <20130521084455.5c651991@tauon>
 <CACXcFm=PCPs23Kd8B0+B7418fSaz=59Z4DRcj3-Wcd-i=Meang@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFm=PCPs23Kd8B0+B7418fSaz=59Z4DRcj3-Wcd-i=Meang@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I continue to be suspicious about claims that userspace timing
measurements are measuring anything other than OS behaviour.  But that
doesn't mean that they shouldn't exist.  Personally, I believe you
should try to collect as much entropy as you can, from as many places
as you can.  For VM's, it means we should definitely use
paravirtualization to get randomness from the host OS.  If you don't
trust the host OS, then what on earth are you doing trying to generate
a long-term public key pair on the VM in the first place?  For that
matter, why are you willing to expose a high value private keypair on
the VM?

For devices like Linux routers, what we desperately need is hardware
assist; either a on-CPU hardware random number generator, or a
hardware RNG from a TPM module, or having an individualized secret key
generated at manufacturing time and burned onto the device.  If you
don't trust that the Intel hardware RNG honest, then by all means mix
in additional timing information either at kernel device driver level,
or from systems such as HAVEGE.

What I'm against is relying only on solutions such as HAVEGE or
replacing /dev/random with something scheme that only relies on CPU
timing and ignores interrupt timing.

Regards,

					- Ted
