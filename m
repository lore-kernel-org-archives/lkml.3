Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaJRKKF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 06:10:05 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:53057 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaJRKKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 06:10:02 -0400
MIME-Version: 1.0
In-Reply-To: <20141016204920.GB16402@hardeman.nu>
References: <1412879436-7513-1-git-send-email-tomas.melin@iki.fi>
	<20141016204920.GB16402@hardeman.nu>
Date: Sat, 18 Oct 2014 13:10:01 +0300
X-Google-Sender-Auth: Wel_CATBFSYO0F36JecboJZc9Jw
Message-ID: <CACraW2pTb0avTdQCLFAZAWNm5ZuTmVDEOPgZGmY+prepLcRANg@mail.gmail.com>
Subject: Re: [PATCH resend] [media] rc-core: fix protocol_change regression in ir_raw_event_register
From: Tomas Melin <tomas.melin@iki.fi>
To: Tomas Melin <tomas.melin@iki.fi>, m.chehab@samsung.com,
        james.hogan@imgtec.com,
        =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:49 PM, David Härdeman <david@hardeman.nu> wrote:
> I think this is already addressed in this thread:
> http://www.spinics.net/lists/linux-media/msg79865.html
The patch in that thread would have broken things since the
store_protocol function is not changed at the same time. The patch I
sent also takes that into account.

My concern is still that user space behaviour changes.
In my case, lirc simply does not work anymore. More generically,
anyone now using e.g. nuvoton-cir with anything other than RC6_MCE
will not get their devices working without first explictly enabling
the correct protocol from sysfs or with ir-keytable.

Correct me if I'm wrong but the change_protocol function in struct
rc_dev is meant for changing hardware decoder protocols which means
only a few drivers actually use it. So the added empty function
change_protocol into rc-ir-raw.c doesnt really make sense in the first
place.

Tomas
