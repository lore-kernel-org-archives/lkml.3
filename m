Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab3BGO5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:57:34 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:40576 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3BGO5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:57:32 -0500
Message-ID: <5113C0D8.60107@suse.cz>
Date: Thu, 07 Feb 2013 15:57:28 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 03/23] n_tty: Don't flush buffer when closing ldisc
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-4-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-4-git-send-email-peter@hurleysoftware.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 09:20 PM, Peter Hurley wrote:
> A buffer flush is both undesirable and unnecessary when the ldisc
> is closing. A buffer flush performs the following:
>  1. resets ldisc data fields to their initial state
>  2. resets tty->receive_room to indicate more data can be sent
>  3. schedules buffer work to receive more data
>  4. signals a buffer flush has happened to linked pty in packet mode
> 
> Since the ldisc has been halted and the tty may soon be destructed,
> buffer work must not be scheduled as that work might access
> an invalid tty and ldisc state. Also, the ldisc read buffer is about
> to be freed, so that's pointless.
> 
> Resetting the ldisc data fields is pointless as well since that
> structure is about to be freed.
> 
> Resetting tty->receive_room is unnecessary, as it will be properly
> reset if a new ldisc is reopened. Besides, resetting the original
> receive_room value would be wrong since the read buffer will be
> gone.
> 
> Since the packet mode flush is observable from userspace, this
> behavior has been preserved.

This one looks good to me.

-- 
js
suse labs
