Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3B0VsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:48:18 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40042 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3B0VsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:48:17 -0500
Message-ID: <512E7F1D.2070401@suse.cz>
Date: Wed, 27 Feb 2013 22:48:13 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Daniel Mack <zonque@gmail.com>, Larry Finger <Larry.Finger@lwfinger.net>,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: disable debugging warning
References: <1362000624-18155-1-git-send-email-jslaby@suse.cz> <20130227214225.GB27224@kroah.com>
In-Reply-To: <20130227214225.GB27224@kroah.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 10:42 PM, Greg KH wrote:
> On Wed, Feb 27, 2013 at 10:30:24PM +0100, Jiri Slaby wrote:
>> We added a warning to flush_to_ldisc to report cases when it is called
>> with a NULL tty. It was for debugging purposes and it lead to a
>> patchset from Peter Hurley. The patchset however did not make it to
>> 3.9, so disable the warning now to not disturb people.
>>
>> We can re-add it when the series is in and we are hunting for another
>> bugs.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> ---
>>  drivers/tty/tty_buffer.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Thanks, I'll queue this up for 3.9-final, but does it also need to go
> into 3.8?

That's a question... In 3.8 it happened too, but very seldomly. Read:
only triggerable by trinity fuzz tester after hours of fuzzing. But
yeah, let's disable it there too so that people won't complain.

thanks,
-- 
js
suse labs
