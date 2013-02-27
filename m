Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab3B0Ltg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:49:36 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:34149 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759616Ab3B0Ltf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:49:35 -0500
MIME-Version: 1.0
In-Reply-To: <512DED86.4060207@ahsoftware.de>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
	<30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<18738.1361836265@warthog.procyon.org.uk>
	<loom.20130227T103444-514@post.gmane.org>
	<CAAMvbhFgNC7fXE2KrDC+aq+Q1dsS7pESvtCrCcMyzJksvARyQQ@mail.gmail.com>
	<512DED86.4060207@ahsoftware.de>
Date: Wed, 27 Feb 2013 11:49:34 +0000
Message-ID: <CAAMvbhF5MRWXZGfLH-GSjSBExrCu48=rz4UGrXwWxHZZY_rcXA@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: ownssh <ownssh@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2013 11:27, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 27.02.2013 11:17, schrieb James Courtier-Dutton:
>
>
>> 3) Trust based on date. I trust everything from X that I put on my
>> system 2 weeks ago, but one week ago X got hacked, so don't trust
>> anything new from them until the hack has been stopped and the
>> revokation/correction steps have been completed.
>> E.g. the Bit9 case, where malware was able to be signed.
>
>
> Which date? In reality dates are (mostly) defined as fixed points, but
> computers just don't have such.
>
> E.g. currently you can't use modsign based on X.509 certificates if the date
> comes through USB, because modsign tries to load the certificate before
> before the USB stack comes up, which ends up with invalid dates (Not
> Before).
> And changing the system date isn't that hard for an attacker if he is
> already able to do other bad things.
>

Maybe date was not a good example.
I think a single chain of trust is risky.
Using multiple signatures on the same binary is better.
e.g. Redhat have signed it, but only load the module if both redhat
and Bit9 have signed it.
In this case, the risk it mitigated, as both Redhat and Bit9 have to
be hacked for the malware to get through.
Now, if a local administrator created a new signing key each time they
installed updates, and the system checked that both the redhat
signature and the local administrator signature were valid before
loading the module, this would give a form of signing based on date.
(the install date)
The local administrator could then quickly revoke the keys for a
particular day, and not have to wait for Redhat to revoke their keys.
