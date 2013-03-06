Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3CFQUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:20:23 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:58925 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab3CFQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:20:19 -0500
Message-ID: <51376CDA.50407@suse.cz>
Date: Wed, 06 Mar 2013 17:20:42 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix session leader exit hang
References: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 01:20 PM, Peter Hurley wrote:
> When a session leader exits, it hangs up the controlling tty and
> then signals the foreground group processes with SIGHUP. This sequence
> can hang as reported by Sasha Levin, and noted in the changelog of
> 'tty: Signal SIGHUP before hanging up ldisc'.
> 
> 
> Peter Hurley (5):
>   tty: Refactor session leader SIGHUP from __tty_hangup()
>   tty: Fix spinlock flavor in non-atomic __tty_hangup()
>   tty: Use spin_lock() inside existing critical region
>   tty: Signal foreground group processes in hangup
>   tty: Signal SIGHUP before hanging up ldisc
> 
>  drivers/tty/tty_io.c | 144 ++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 96 insertions(+), 48 deletions(-)
> 

Hi, all three series look good to me.

-- 
js
suse labs
