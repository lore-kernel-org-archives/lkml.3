Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722Ab3B0TOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:14:39 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:63003 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3B0TOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:14:38 -0500
Message-ID: <512E5B16.4050002@redhat.com>
Date: Wed, 27 Feb 2013 20:14:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Peter Jones <pjones@redhat.com>,
        Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <20130226030249.GB23834@kroah.com> <20130226031338.GA29784@srcf.ucam.org> <20130226033156.GA24999@kroah.com> <20130226033803.GA30285@srcf.ucam.org> <20130226035416.GA1128@kroah.com> <20130226040456.GA30717@srcf.ucam.org> <20130226041324.GA7241@kroah.com> <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com> <20130226044521.GC12906@thunk.org> <20130226165451.GE32160@fenchurch.internal.datastacks.com> <20130227152429.GA5609@thunk.org> <512E4409.2040907@genband.com>
In-Reply-To: <512E4409.2040907@genband.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 27/02/2013 18:36, Chris Friesen ha scritto:
> On 02/27/2013 09:24 AM, Theodore Ts'o wrote:
>> On Tue, Feb 26, 2013 at 11:54:51AM -0500, Peter Jones wrote:
>>> No, no, no.  Quit saying nobody knows.  We've got a pretty good idea -
>>> we've got a contract with them, and it says they provide the signing
>>> service, and under circumstances where the thing being signed is found
>>> to enable malware that circumvents Secure Boot
>>
>> The question is what does "malware that circuments Secure Boot" mean?
>> Does starting up a hacked KVM and running Windows 8 under KVM so that
>> malare can be injected count as circumenting Secure Boot?  If so, will
>> you have to disable KVM, too?
> 
> I could see an argument for KVM to require either a signed binary or
> else someone at the keyboard to explicitly okay loading the image.
> Anything else breaks the chain of trust.

Not just the executable; the firmware would also need to be signed.

In fact, I think requiring signed KVM binaries and signed VM firmwares
makes sense in the long term, but you have to stop somewhere.

And BTW you can always emulate the instruction set instead of using
hardware virtualization.  This way the kernel is not involved.  It's a
slippery slope and leads you straight to the app store model and
restrictions on interpreters like Apple's.

Certainly an attack using unsigned modules is trivial, unlike one that
virtualizes the victim OS, and also much harder to discover
(virtualization is easy to detect by timing certain operations in the
guest).  Just for this reason, putting unsigned modules on the "no" side
makes much more sense than putting virtualization on the "no" side.

Paolo

> It may be somewhat far-fetched, but I think it would be possible to take
> an existing secure-boot Win 8 install, turn it into a VM but with an
> infected kernel. Then install a signed Linux distro that runs the Win8
> VM as a guest.
> 
> At this point you've got a running infected Win8 install that is running
> on Secure Boot hardware but is actually running malware.
> 
> Admittedly this would be tricky to do reliably in a way that the user
> doesn't notice, so it may not actually be a real-world threat.
> 
> Chris

