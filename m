Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaEAT0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:26:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:44333 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaEAT0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:26:33 -0400
Date: Thu, 1 May 2014 19:26:18 +0000
From: tytso@mit.edu
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Florian Weimer <fweimer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <kees@outflux.net>, kvm list <kvm@vger.kernel.org>
Subject: Re: random: Providing a seed value to VM guests
Message-ID: <20140501192618.GA25829@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andy Lutomirski <luto@amacapital.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Florian Weimer <fweimer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Kees Cook <kees@outflux.net>, kvm list <kvm@vger.kernel.org>
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 12:02:49PM -0700, Andy Lutomirski wrote:
> 
> Is RDSEED really reasonable here?  Won't it slow down by several
> orders of magnitude?

That is I think the biggest problem; RDRAND and RDSEED are fast if
they are native, but they will involve a VM exit if they need to be
emulated.  So when an OS might want to use RDRAND and RDSEED might be
quite different if we know they are being emulated.

Using the RDRAND and RDSEED "api" certainly makes sense, at least for
x86, but I suspect we might want to use a different way of signalling
that a VM guest can use RDRAND and RDSEED if they are running on a CPU
which doesn't provide that kind of access.  Maybe a CPUID extended
function parameter, if one could be allocated for use by a Linux
hypervisor?

						- Ted

