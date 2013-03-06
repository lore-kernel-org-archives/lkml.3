Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3CFQWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:22:52 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55902 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3CFQWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:22:47 -0500
Message-ID: <51376D6F.1070202@suse.cz>
Date: Wed, 06 Mar 2013 17:23:11 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: jhovold@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: [PATCH v2 0/4] TTY: port hangup and close fixes]
References: <1362085054.3337.20.camel@thor.lan> <51361724.4050107@suse.cz>   <1362503170.18799.33.camel@thor.lan> <51366A29.2060808@suse.cz>  <1362520976.18799.134.camel@thor.lan> <51366D3E.2050903@suse.cz> <1362522724.18799.149.camel@thor.lan>
In-Reply-To: <1362522724.18799.149.camel@thor.lan>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 11:32 PM, Peter Hurley wrote:
>>  So I'm thinking about
>> something like this:
>>
>> if (port->tty)
>>    set_bit(TTY_IO_ERROR, &port->tty->flags);
>> tty = port->tty; <=== take a snapshot
>> spin_unlock_irqrestore(&port->lock, flags);
>> tty_port_shutdown(port, tty); <=== use the snapshot
>> set_tty_port(port, NULL); <=== put kref on that tty
> 
> Yeah, that's better.

But still not correct. The tty can be invalid (freed) at the time
tty_port_shutdown is called. We should take a real reference inside the
lock and put the reference explicitly after the call.

-- 
js
suse labs
