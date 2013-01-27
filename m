Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3A0URJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 15:17:09 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:37904 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab3A0URH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 15:17:07 -0500
Message-ID: <51058B3B.3010400@suse.cz>
Date: Sun, 27 Jan 2013 21:16:59 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] TTY: synclink, small cleanup in dtr_rts()
References: <20130127194039.GA18787@elgon.mountain> <1359317078.14406.12.camel@joe-AO722>
In-Reply-To: <1359317078.14406.12.camel@joe-AO722>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 09:04 PM, Joe Perches wrote:
> On Sun, 2013-01-27 at 22:40 +0300, Dan Carpenter wrote:
>> There is a kind of precedence problem here, but it doesn't affect how
>> the code works because ->serial_signals is unsigned char.  We want to
>> clear two flags here.
>>
>> #define SerialSignal_RTS            0x20     /* Request to Send */
>> #define SerialSignal_DTR            0x80     /* Data Terminal Ready */
>>
>> Without the parenthesis then it does:
>>
>> 	info->serial_signals &= 0x5f;
>>
>> With the parenthesis it does:
>>
>> 	info->serial_signals &= 0xffffff5f;
>>
>> info->serial_signals is an unsigned char so the two statements are
>> equivalent, but it's cleaner to add the parenthesis.  In other dtr_rts()
>> functions the parenthesis are there so this makes it more consistent.
> 
> 
> Wouldn't it be clearer still to use | instead of +

Ack, the plus is a mindfuck.


-- 
js
suse labs
