Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbaGOJQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:16:10 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:58021 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbaGOJQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:16:08 -0400
Message-ID: <53C4F154.3000009@suse.cz>
Date: Tue, 15 Jul 2014 11:16:04 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Li, ZhenHua" <zhen-hual@hp.com>, Peter Hurley <peter@hurleysoftware.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/tty: Fix a warning in check_tty_count
References: <1405317257-5491-1-git-send-email-zhen-hual@hp.com> <53C3CC4E.9010000@hurleysoftware.com> <53C4EFA8.3080308@hp.com>
In-Reply-To: <53C4EFA8.3080308@hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/15/2014 11:08 AM, Li, ZhenHua wrote:
> This bug  was founded in RHEL 6, kernel version 2.6.32.
> 
> But I also checked the file tty_io.c in  latest kernel, not all the code
> protected by tty_lock(tty).
> 
> For example,  in function tty_del_file,
> 
>     if (--tty->count < 0) {
>     }
> and
>     tty_del_file(filp);
> are not surrounded by tty_lock(tty).

Sure, but there is tty_lock_pair instead.

> So I think the new lock is necessary.

Nope, sorry, you have to complain to RedHat about this kernel. Unless
you can reproduce this with the vanilla kernel.

thanks,
-- 
js
suse labs
