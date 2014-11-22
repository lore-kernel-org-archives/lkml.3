Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaKVCQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 21:16:52 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:55324 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaKVCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 21:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141121181334.GC4274@pd.tnic>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
	<20141119102954.GA5617@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
	<20141120101505.GA791@pd.tnic>
	<CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
	<20141121164140.GA4274@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
	<20141121181334.GC4274@pd.tnic>
Date: Sat, 22 Nov 2014 10:16:49 +0800
Message-ID: <CANVTcTa_AVM01VeVBYiSiB3Q0sJagy2hh-xYAjJv70jCWoDHYA@mail.gmail.com>
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
From: rui wang <ruiv.wang@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/14, Borislav Petkov <bp@alien8.de> wrote:
>... there are two possibilities:
>
> * error got logged into mcelog and is long out to dmesg.
>
> So we go look at dmesg. Not very easy to do when we panic, I know, so we
> better make sure we have serial connected.
>
>
>  [ Btw., we can know when userspace is eating up error data:
>    drivers/ras/debugfs.c. If it doesn't, we can then dump it to dmesg.
>    We'll have to teach mcelog/ras daemons to open that file so that we
>    don't issue to dmesg. ]
>
>
> * error is not logged yet so still in mcelog and we simply dump it out
> to dmesg.
>
> In any case, we cannot have fixed-size buffer for some number of errors
> and rely on it always having the error which caused the #MC as something
> will consume it at some point anyway.
>
> So maybe if we could get a more detailed explanation of when this thing
> happens, then we might address it better.
>

Hi Boris,
I think both possibilities are valid. But experiments show that the
error logs are not in the dmesg preserved by kdump in /var/crash/
after panic and reboot, and not in the mcelog.entry[] array in the
kernel. So they must be somewhere in user space memory. Even if we
have serial console connected we still can't cache them. The
difficulty is that there's no easy way to force a user space daemon to
do something during panic.

The new banks_saved[] array acts like a safe guard when you pass
something to someone else - to prevent it from getting lost in the
interim.

Thanks
Rui
