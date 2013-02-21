Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3BUSMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:12:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41726 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3BUSME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:12:04 -0500
Date: Thu, 21 Feb 2013 18:11:57 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130221181157.GA21688@srcf.ucam.org>
References: <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
 <20130221174955.GA20886@srcf.ucam.org>
 <CA+55aFxZ4f4KiHQBCAgTghm+deniS6rDz4wna9bce6vK8WppsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxZ4f4KiHQBCAgTghm+deniS6rDz4wna9bce6vK8WppsA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:03:20AM -0800, Linus Torvalds wrote:

> Seriously, if somebody wants to make a binary module for Fedora 18 or
> whatever, they should go to Red Hat and ask whether RH is willing to
> sign their key. And the whole "no, we only think it makes sense to
> trust MS keys" argument is so f*cking stupid that if somebody really
> brings that up, I can only throw my hands up and say "whatever".

MS have infrastructure to do identity verification and actually run some 
kind of vaguely responsible CA, and I don't trust Red Hat to be able to 
do that. And if the machine's carrying Microsoft's key in its firmware 
then you *already* trust Microsoft, because if the bad guy can get 
something signed by them then he's already just replaced your bootloader 
instead of pissing about inserting modules. Using the hardware keys as 
the root of trust makes practical sense.

> Besides, let's face it, Red Hat is going to sign the official nVidia
> and AMD binary modules anyway. Don't even bother to pretend anything
> else.

I don't think there's any chance of them signing modules. But it's a 
given that RHEL's going to end up trusting keys owned by nvidia and amd 
somehow, and chances are that's going to be based on the Microsoft 
signing service. The question is whether there's a benefit in ensuring 
that the same key is trusted by RHEL, Ubuntu, Suse and everyone else or 
whether different kernels are going to have completely different 
policies.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
