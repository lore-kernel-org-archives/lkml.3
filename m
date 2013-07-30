Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab3G3A4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:56:33 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:41092 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab3G3A4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:56:31 -0400
From: Nix <nix@esperi.org.uk>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nick.cheng@areca.com.tw, stable@vger.kernel.org
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <51F708A4.9090207@interlog.com>
Emacs: why choose between a word processor and a Lisp interpreter when you could have neither instead?
Date: Tue, 30 Jul 2013 01:56:20 +0100
In-Reply-To: <51F708A4.9090207@interlog.com> (Douglas Gilbert's message of
	"Mon, 29 Jul 2013 20:28:20 -0400")
Message-ID: <87ob9koogb.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-URT-Metrics: spindle 1060; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 Jul 2013, Douglas Gilbert outgrape:

> Please supply the information that Martin Petersen asked
> for.

Did it in private IRC (the advantage of working for the same division of
the same company!)

I didn't realise the original fix was actually implemented to allow
Bernd, with a different Areca controller, to boot... obviously, in that
situation, reversion is wrong, since that would just replace one won't-
boot situation with another.

It looks like a solution is possible that will let us boot *both* my
controller (with its old 2009-era firmware) *and* his. We just have
to let Martin implement it. Give him time, I only got a successful
boot out of it an hour ago :)

> I just examined a more recent Areca SAS RAID controller
> and would describe it as the SCSI device from hell. One solution
> to this problem is to modify the arcmsr driver so it returns
> a more consistent set of lies to the management SCSI commands that
> Martin is asking about.

I can't help notice that something is skewy in its error handling, too.
When the controller errors, even resetting the bus doesn't seem to be
enough to bring it back :/ I've seen errors from it before which did
*not* lead to it imploding forever, but this is apparently not one such.

Certainly Areca-the-company has... issues with communication with the
community (i.e., they don't). A shame I didn't know that before I bought
the controller and made all my data completely dependent on it, really.
Shame, the controller otherwise works very well (fast, and has coped
with a disk failure with aplomb).

-- 
NULL && (void)
