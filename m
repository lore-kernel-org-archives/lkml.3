Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3B0KRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:17:18 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:36257 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3B0KRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:17:17 -0500
MIME-Version: 1.0
In-Reply-To: <loom.20130227T103444-514@post.gmane.org>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
	<30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<18738.1361836265@warthog.procyon.org.uk>
	<loom.20130227T103444-514@post.gmane.org>
Date: Wed, 27 Feb 2013 10:17:16 +0000
Message-ID: <CAAMvbhFgNC7fXE2KrDC+aq+Q1dsS7pESvtCrCcMyzJksvARyQQ@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: James Courtier-Dutton <james.dutton@gmail.com>
To: ownssh <ownssh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2013 09:35, ownssh <ownssh@gmail.com> wrote:
> David Howells <dhowells <at> redhat.com> writes:
>
>>
>>
>> Florian Weimer <fw <at> deneb.enyo.de> wrote:
>>
>> > Seriously, folks, can we go back one step and discuss what problem you
>> > are trying to solve?  Is it about allowing third-party kernel modules
>> > in an environment which does not allow unsigned ring 0 code execution?
>>
>> Let me try and lay things out:
>>
>>  (1) Like it or not, the reality is that machines exist that have UEFI secure
>
> I think, redhat should have their own root key to sign binary files.
> Bootloader of install media can be sign by MS certificates, but only use to add
> the redhat root key to UEFI database before install.
> It will solve many problems like MS blacklist the keys although redhat said MS
> wont do that forever.
>
> And, even you do the all things of A-G, it still wont safe because many
> vulnerabilities can let the attacker enter ring0 only use to exploit the exist
> signed kernel module or kernel itself.
>

One way to judge if this is a good solution or not is to list what the
threats are, and see how well the solution mitigates those.
I will list a few I would like:
1) Tamper evindence.
2) Fast trust revokation and correction.
3) Trust based on date. I trust everything from X that I put on my
system 2 weeks ago, but one week ago X got hacked, so don't trust
anything new from them until the hack has been stopped and the
revokation/correction steps have been completed.
E.g. the Bit9 case, where malware was able to be signed.

I think secure boot does a very week version of (1) and is very slow
at (2), and does not do (3).
The ARM version of secure boot is maybe slightly better, it does a
good job of (1) but at the expense some of (2).
I.e. the root certificate is in ROM on ARM and not EEPROM on x86.
It is difficult to tamper with ROM, so you have a much stronger tamper
evindence solution.
Unfortunately, if the root certificate in the ROM is compromised, you
cannot revoke it and correct it.

Kind Regards
				
James
