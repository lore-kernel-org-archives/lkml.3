Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3H3KCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:02:18 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:37570 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3H3KCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:02:16 -0400
From: Nix <nix@esperi.org.uk>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi disk: Use its own buffer for the vpd request
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net>
	<51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net>
	<51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm>
	<51FA71E2.6010501@fastmail.fm>
Emacs: the answer to the world surplus of CPU cycles.
Date: Fri, 30 Aug 2013 11:01:56 +0100
In-Reply-To: <51FA71E2.6010501@fastmail.fm> (Bernd Schubert's message of "Thu,
	01 Aug 2013 16:34:10 +0200")
Message-ID: <871u5b7azv.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=8 Fuz1=8 Fuz2=8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Aug 2013, Bernd Schubert said:

> Once I noticed that scsi_get_vpd_page() works fine from other function
> calls and that it is not 0x89, but already 0x0 that fails fixing it became
> easy.
>
> Nix, any chance you could verify it also works for you?

As an aside, this commit does indeed fix the bug I reported, but it
doesn't seem to have gone anywhere, not even into -stable.

Is it held up somehow?

(stable has

commit 0ac10bd036f0f3b8ce7ac2390446eab9531c72eb
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Tue Jul 30 22:58:34 2013 -0400

    SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_pages is set

which IIRC was eventually found not to be necessary, because this fix
works fine instead?)

Possibly I'm misremembering the order of month-old events and Martin's
fix was eventually considered better... in which case, sorry for the noise.

-- 
NULL && (void)
