Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3CTOY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:24:58 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39215 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3CTOY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:24:56 -0400
Message-ID: <5149C4E8.5020707@suse.cz>
Date: Wed, 20 Mar 2013 15:17:12 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
References: <20130320125137.EDCD3802B0@viridian.itc.virginia.edu>
In-Reply-To: <20130320125137.EDCD3802B0@viridian.itc.virginia.edu>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 01:51 PM, Bill Pemberton wrote:
> Jiri Slaby writes:
>>
>>> drivers/usb/serial/quatech2.c: In function 'qt2_process_read_urb': 
>>> drivers/usb/serial/quatech2.c:661:18: error: 'struct
>>> qt2_port_private' has no member named 'is_open' 
>>> drivers/usb/serial/quatech2.c:705:15: error: 'struct
>>> qt2_port_private' has no member named 'is_open'
>>>
>>> Caused by commit e4408ce3c23f ("TTY: quatech2, remove unneeded 
>>> is_open").  grep is your friend (or searching while editting the
>>> file).
>>
>> I think this is caused by another commit. Bill added a check for
>> is_open meanwhile I removed that member completely. Bill, could you
>> fix that up, please?
>>
> 
> Is it legal to call tty_flip_buffer_push() without an open tty?  If
> so, I can get rid of the is_open logic completely.  Otherwise, I need
> to either keep is_open or otherwise check for a valid tty before
> calling tty_flip_buffer_push().

Yeah, it is legal to call that, as long as you have a valid tty_port.
Now, the data are queued and later flushed. The plan is to throw the
data directly on ingress in a way the drivers don't need to care.

thanks,
-- 
js
suse labs
