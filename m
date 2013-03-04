Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3CDJlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:41:13 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60294 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3CDJlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:41:11 -0500
Message-ID: <51346C33.6080504@suse.cz>
Date: Mon, 04 Mar 2013 10:41:07 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty/serial: Fix uninitialized variable warning
References: <1362360907-4439-1-git-send-email-grant.likely@secretlab.ca> <1362364613.3221.144.camel@thor.lan>
In-Reply-To: <1362364613.3221.144.camel@thor.lan>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 03:36 AM, Peter Hurley wrote:
> On Mon, 2013-03-04 at 09:35 +0800, Grant Likely wrote:
>> drivers/tty/serial/8250/8250.c: In function 'serial_unlink_irq_chain':
>> drivers/tty/serial/8250/8250.c:1676:19: warning: 'i' may be used uninitialized in this function
>>
>> There isn't an actual bug here since the function tests the condition
>> that would cause i to be uninitialized before dereferencing i. However,
>> at least some versions of GCC complain as shown above. (in my case,
>> powerpc gcc 2.5.2). Initializing i to NULL makes it clear to GCC and the
>> casual code reviewer that i will not be dereferenced to a random
>> address.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>> Greg, some may argue that this is a tool problem, not a kernel problem,
>> but it is useful to me. If anyone objects I'm not going to spend any
>> time championing for this patch.
>>
>> g.
>>
>>  drivers/tty/serial/8250/8250.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
>> index 0efc815..cbbedcf 100644
>> --- a/drivers/tty/serial/8250/8250.c
>> +++ b/drivers/tty/serial/8250/8250.c
>> @@ -1673,7 +1673,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
>>  
>>  static void serial_unlink_irq_chain(struct uart_8250_port *up)
>>  {
>> -	struct irq_info *i;
>> +	struct irq_info *i = NULL;
> 
> struct irq_info *uninitialized_var(i);
> 
> For gcc, the uninitialized_var() #define is in
> include/linux/compiler-gcc.h

As far as I remember, we decided not to use that macro any more after a
bug stemming out of its use.

And Grant uses a very old toolchain as we can see in the commit log. I'm
not sure whether it's worth to hide a potential bug in the future by
this patch.

thanks,
-- 
js
suse labs
