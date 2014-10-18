Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaJRSTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 14:19:07 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:36604 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaJRSTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 14:19:05 -0400
X-AuditID: cbfec372-b7f666d000001846-e1-5442af1617b9
Date: Sat, 18 Oct 2014 20:18:56 +0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Tomas Melin <tomas.melin@iki.fi>
Cc: james.hogan@imgtec.com,
        Antti =?ISO-8859-1?B?U2VwcORs5A==?= <a.seppala@gmail.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] [media] rc-core: fix protocol_change regression in
 ir_raw_event_register
Message-id: <20141018201856.6e7a8435.m.chehab@samsung.com>
In-reply-to: <CACraW2pTb0avTdQCLFAZAWNm5ZuTmVDEOPgZGmY+prepLcRANg@mail.gmail.com>
References: <1412879436-7513-1-git-send-email-tomas.melin@iki.fi>
 <20141016204920.GB16402@hardeman.nu>
 <CACraW2pTb0avTdQCLFAZAWNm5ZuTmVDEOPgZGmY+prepLcRANg@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t/hIF2x9U4hBsdWG1hs/XaTzeLdvBfM
	Fpd3zWGz6NmwldVi7vKrjA6sHjtn3WX3OPx1IYtHz84zjB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZczsvcFWsJu34nL7erYGxstcXYycHBICJhJ7WntZIGwxiQv31rN1MXJxCAksYZSYtaWDEcJp
	ZJKYsPIyK0gVi4CqxJV7rYwgNpuAkcSrxhawuIiAisTZo3PBupkFZjNKvD06jx0kISyQJrG3
	uQnM5hWwkthzfiUziM0pECzx+OkGdogN6xkl3t/qBurmALrDWWL+52yIekGJH5PvgZ3HLKAj
	sb91GhuErS3x5N0F1gmMArOQlM1CUjYLSdkCRuZVjKKlxckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GCGhXLSD8dkGq0OMAhyMSjy8C046hgixJpYVV+YeYpTgYFYS4Z06GSjEm5JYWZValB9fVJqT
	WnyIkYmDU6qB0XjzqRsfug94N96fdPVvzF0jp7d71CbtLYpSdT+oFPdbNbpq2Y7MyX8tp7/Q
	kvZo9riSFCLNtvJKt1aT61WOHG6jWtMO2amrRDpKpdyTZ4j881v6y9Wc7ZCGGfectskRfLf4
	p2xckbxLI2fXt1Mn1T+slrWsb0mUauN6NMNcs6m7z+WWctlfJZbijERDLeai4kQA1qZAmUMC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 18 Oct 2014 13:10:01 +0300
Tomas Melin <tomas.melin@iki.fi> escreveu:

> On Thu, Oct 16, 2014 at 11:49 PM, David Härdeman <david@hardeman.nu> wrote:
> > I think this is already addressed in this thread:
> > http://www.spinics.net/lists/linux-media/msg79865.html
> The patch in that thread would have broken things since the
> store_protocol function is not changed at the same time. The patch I
> sent also takes that into account.
> 
> My concern is still that user space behaviour changes.
> In my case, lirc simply does not work anymore.

Yeah, lirc should be enabled by default.

> More generically,
> anyone now using e.g. nuvoton-cir with anything other than RC6_MCE
> will not get their devices working without first explictly enabling
> the correct protocol from sysfs or with ir-keytable.

The right behavior here is to enable the protocol as soon as the
new keycode table is written by userspace.

Except for LIRC and the protocol of the current table enabled is
not a good idea because:

	1) It misread the code from some other IR;
	2) It will be just spending power without need, running
	   several tasks (one for each IR type) with no reason, as the
	   keytable won't match the codes for other IRs (and if it is
	   currently matching, then this is a bad behavior).

> Correct me if I'm wrong but the change_protocol function in struct
> rc_dev is meant for changing hardware decoder protocols which means
> only a few drivers actually use it.

Actually, most drivers are for hardware decoders.

> So the added empty function
> change_protocol into rc-ir-raw.c doesnt really make sense in the first
> place.
> 
> Tomas


-- 

Cheers,
Mauro
