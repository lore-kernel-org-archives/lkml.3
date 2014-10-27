Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaJ0WNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:13:53 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43287 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752407AbaJ0WNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:13:51 -0400
Message-ID: <544EC39C.3010703@hurleysoftware.com>
Date: Mon, 27 Oct 2014 18:13:48 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -next 20/27] tty: Refactor __tty_hangup to enable lockdep
 annotation
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com> <1413491125-20134-21-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1413491125-20134-21-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 04:25 PM, Peter Hurley wrote:
> Refactor __tty_hangup() into:
> 1. __tty_hangup_common(), the portion requiring the tty lock
> 2. __tty_hangup(), which performs the pre- and post-lock processing
>    (TIOCCONS redirect undo) and calls through a function ptr parameter
>    to lock/hangup/unlock
> 3. __tty_hangup_standard(), which performs the lock/hangup/unlock
> 
> Allows an alternate function to lock/hangup/unlock with the
> nested tty lock.

I just discovered that lockdep provides an interface for setting the
lock subclass after lock initialization. Which means that the lock
subclass can be changed just for slave ptys, which allows lock nesting
without specifying the subclass at lock time. Which eliminates the need
for this patch and the follow-on.

I'll respin this series.

Regards,
Peter Hurley

