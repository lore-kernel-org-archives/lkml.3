Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741Ab3CMORu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:17:50 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:39012 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab3CMORs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:17:48 -0400
Message-ID: <51408A88.20202@suse.cz>
Date: Wed, 13 Mar 2013 15:17:44 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
CC: gregkh@linuxfoundation.org, peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/16] TTY: quatech2, remove unneeded is_open
References: <20130313134601.ED7598028B@viridian.itc.virginia.edu>
In-Reply-To: <20130313134601.ED7598028B@viridian.itc.virginia.edu>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 02:46 PM, Bill Pemberton wrote:
> Jiri Slaby writes:
>>
>> tty->ops->break_ctl cannot be called outside the gap between open and
>> close. So there is no need to check whether the port is open in
>> break_ctl in quatech2. Remove the check and also that member
>> completely.
>>
> 
> We can't get rid of is_open.  The devices use 1 read urb for all ports
> and will send various things about ports that haven't actually been
> opened.  So the driver needs to know if a port has actually been
> opened or not.  In fact, I was about to send a patch that fixes a
> warning caused by commit 2e124b4a390ca85325fae75764bef92f0547fa25
> causing the driver to try to write to ttys that weren't actually
> opened.

As long as tty_port exists for the port, calling tty buffer functions is
OK. The warning you mention is now bogus and there is a patch flying
around to disable that at the moment.

It is also that is_open was completely racy, right?

> The guard in qt2_break_ctl() can still be removed.

Ok.

thanks,
-- 
js
suse labs
