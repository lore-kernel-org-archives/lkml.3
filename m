Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaJSKOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 06:14:14 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:46771 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaJSKOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 06:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <20141018201856.6e7a8435.m.chehab@samsung.com>
References: <1412879436-7513-1-git-send-email-tomas.melin@iki.fi>
	<20141016204920.GB16402@hardeman.nu>
	<CACraW2pTb0avTdQCLFAZAWNm5ZuTmVDEOPgZGmY+prepLcRANg@mail.gmail.com>
	<20141018201856.6e7a8435.m.chehab@samsung.com>
Date: Sun, 19 Oct 2014 13:14:11 +0300
X-Google-Sender-Auth: dTSpUuK8weOhx8L3kfrnFy56R1g
Message-ID: <CACraW2o3A2vr-a+_47=tL22uUP8h+M5-aGb5Vdq5xsQekN1waQ@mail.gmail.com>
Subject: Re: [PATCH resend] [media] rc-core: fix protocol_change regression in ir_raw_event_register
From: Tomas Melin <tomas.melin@iki.fi>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: james.hogan@imgtec.com,
        =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 9:18 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
>
> The right behavior here is to enable the protocol as soon as the
> new keycode table is written by userspace.
>
> Except for LIRC and the protocol of the current table enabled is
> not a good idea because:
>
>         1) It misread the code from some other IR;
>         2) It will be just spending power without need, running
>            several tasks (one for each IR type) with no reason, as the
>            keytable won't match the codes for other IRs (and if it is
>            currently matching, then this is a bad behavior).
>
I agree, it sounds overkill to have all protocols enabled by default.
I'll make a new patch that enables lirc but disables other protocols
during registration.

Tomas
