Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3BLC2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 21:28:17 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50884 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3BLC2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 21:28:15 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6sEmcyRveM9630qyGQm21ZUhSMKTThDnO+MMu=ejfdP2w@mail.gmail.com>
References: <1360406062-14982-1-git-send-email-grant.likely@secretlab.ca>
 <51187376.2060106@nvidia.com> <CACxGe6sEmcyRveM9630qyGQm21ZUhSMKTThDnO+MMu=ejfdP2w@mail.gmail.com>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Tue, 12 Feb 2013 11:27:54 +0900
X-Google-Sender-Auth: _pCT6JofiFudtD7Rmw8kYkdRdzs
Message-ID: <CAAVeFu+vRLSRMDt4tqmyzYu1DPy7RwCt80e5W7issHY_4MCC_g@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Fix locking on gpio debugfs files
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 8:31 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Feb 11, 2013 at 4:28 AM, Alex Courbot <acourbot@nvidia.com> wrote:
>> Just wondering: if we manage to change this spinlock into a mutex in the
>> future, wouldn't it be better to acquire it only once in gpiolib_seq_start()
>> and release it in gpiolib_seq_stop()?
>>
>> Even though the protection introduced by this patch definitely improves the
>> situation, it seems to me that chips could still be removed while being
>> displayed by gpiolib_seq_show().
>
> Probably, but need to first verify that the mutex won't end up getting
> held between read() syscalls. Otherwise it would be possible to block
> addition/removal by holding the file open. I cursory read of seq_file
> looks like ->stop() is always called, but I would appreciate someone
> more cluefull to give an opinion here.

While not cluefull in any way, I nonetheless had a quick look at all
the control paths of seq_read(), and indeed op->stop() seems to be
called in each of them.

> I've also got a draft patch that turns gpio chips into first-class
> kobjects which means we can do proper reference counting on them and
> prevent the structure from actually disappearing while other drivers
> still hold references.

Oooh. Looking forward to seeing this. :)

Alex.
