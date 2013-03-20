Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab3CTIQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:16:31 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34150 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab3CTIQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:16:28 -0400
Message-ID: <5149707F.5050003@suse.cz>
Date: Wed, 20 Mar 2013 09:17:03 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: linux-next: build failure after merge of the tty tree
References: <20130320141211.52b44d0e202d32812c3e3c0c@canb.auug.org.au>
In-Reply-To: <20130320141211.52b44d0e202d32812c3e3c0c@canb.auug.org.au>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/20/2013 04:12 AM, Stephen Rothwell wrote:
> drivers/net/caif/caif_serial.c: In function 'update_tty_status': 
> drivers/net/caif/caif_serial.c:94:11: error: 'struct tty_struct'
> has no member named 'warned'
> 
> Caused by commit 6865ff222cca ("TTY: do not warn about setting
> speed via SPD_*").

I wonder why this didn't trigger locally. I have to check if I have
debugfs enabled. In any way, I will send a patch to fix this later today.

> drivers/usb/serial/quatech2.c: In function 'qt2_process_read_urb': 
> drivers/usb/serial/quatech2.c:661:18: error: 'struct
> qt2_port_private' has no member named 'is_open' 
> drivers/usb/serial/quatech2.c:705:15: error: 'struct
> qt2_port_private' has no member named 'is_open'
> 
> Caused by commit e4408ce3c23f ("TTY: quatech2, remove unneeded 
> is_open").  grep is your friend (or searching while editting the
> file).

I think this is caused by another commit. Bill added a check for
is_open meanwhile I removed that member completely. Bill, could you
fix that up, please?

thanks,
-- 
js
suse labs
