Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483Ab3B0RXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:23:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49212 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab3B0RX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:23:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130226031338.GA29784@srcf.ucam.org>
	<20130226032508.GA12906@thunk.org>
	<20130226032839.GA30164@srcf.ucam.org>
	<CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
	<20130226034250.GB30285@srcf.ucam.org>
	<CA+55aFzn4KGKtn6cXN-jh9jgF+U1zJUnCmk6tRxmW8BZP7_Jnw@mail.gmail.com>
	<20130226034842.GD30285@srcf.ucam.org>
	<CA+55aFyAfgqmxGnh+WpZjgR5qKd+CLr1S7gKnXihqJXB346DqQ@mail.gmail.com>
	<20130226045747.GA31181@srcf.ucam.org>
	<20130226153045.GA10535@redhat.com>
	<20130226153846.GA16094@redhat.com>
Date: Wed, 27 Feb 2013 09:23:08 -0800
In-Reply-To: <20130226153846.GA16094@redhat.com> (Vivek Goyal's message of
	"Tue, 26 Feb 2013 10:38:46 -0500")
Message-ID: <87zjypd62r.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+kKy0GfhbvgKezk+WoIYo5J8DLqdmD9RE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0429]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] Load keys from signed PE binaries
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Feb 26, 2013 at 10:30:45AM -0500, Vivek Goyal wrote:
>> On Tue, Feb 26, 2013 at 04:57:47AM +0000, Matthew Garrett wrote:
>> 
>> [..]
>> > >  - encourage things like per-host random keys - with the stupid UEFI
>> > > checks disabled entirely if required. They are almost certainly going
>> > > to be *more* secure than depending on some crazy root of trust based
>> > > on a big company, with key signing authorities that trust anybody with
>> > > a credit card. Try to teach people about things like that instead.
>> > > Encourage people to do their own (random) keys, and adding those to
>> > > their UEFI setups (or not: the whole UEFI thing is more about control
>> > > than security), and strive to do things like one-time signing with the
>> > > private key thrown out entirely. IOW try to encourage *that* kind of
>> > > "we made sure to ask the user very explicitly with big warnings and
>> > > create his own key for that particular module" security. Real
>> > > security, not "we control the user" security.
>> > 
>> > Yes, ideally people will engage in self-signing and distributions will 
>> > have mechanisms for dealing with that.
>> 
>> So even if a user installs its own keys in UEFI to boot self signed
>> shim, kernel and modules, I am assuming that we will still need to
>> make sure kexec does not load and run an unsigned kernel? (Otherwise
>> there is no point in installing user keys in UEFI and there is an
>> easy way to bypass it). 
>
> As I am kind of lost in the long mail thread, so I will ask. If a user
> installs its own keys in UEFI database and boots self signed linux
> kernel, will we still make sure that no unsigned code can be run at
> ring 0 (without explicitly asking user on console).

The short version is what I said at the start.

Whatever kexec does should make sense outside of the context of UEFI and
secure boot.

The point of installing user keys in UEFI is so that the user has
control of when other keys are trusted.  So that the user is not
required to trust Microsoft, or anything signed by Microsoft.  So that
the user has control of the start of the boot process.

One way or another the bad-guys will figure out how to get into
ring0. UEFI secure boot at best means you can wrest back control of your
machine from the bad-guys after that happens.

What kexec checking signatures fundamentally does is make it hard for a
bad guy to pull a fast one and get you to boot a compromised kernel.
That is an interesting problem regardless of secure boot.

Eric
