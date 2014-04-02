Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161020AbaDBWaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:30:18 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45469 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030634AbaDBWaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:30:17 -0400
Message-ID: <533C8F75.9000301@gmail.com>
Date: Wed, 02 Apr 2014 15:30:13 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mateusz Guzik <mguzik@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com>
In-Reply-To: <20140402221212.GD16570@mguzik.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 03:12 PM, Mateusz Guzik wrote:
> On Wed, Apr 02, 2014 at 02:42:19PM -0400, Steven Rostedt wrote:
>> It has come to our attention that a system running a specific user
>> space init program will not boot if you add "debug" to the kernel
>> command line. What happens is that the user space tool parses the
>> kernel command line, and if it sees "debug" it will spit out so much
>> information that the system fails to boot. This basically renders the
>> "debug" option for the kernel useless.
>>
>> This bug has been reported to the developers of said tool
>> here:
>>
>>    https://bugs.freedesktop.org/show_bug.cgi?id=76935
>>
>> The response is:
>>
>> "Generic terms are generic, not the first user owns them."
>>
>> That is, the "debug" statement on the *kernel* command line is not
>> owned by the kernel just because it was the first user of it, and
>> they refuse to fix their bug.
>>
>> Well, my response is, we OWN the kernel command line, and as such, we
>> can keep the users from seeing stuff on it if we so choose. And with
>> that, I propose this patch, which hides "debug" from /proc/cmdline,
>> such that we don't have to worry about tools parsing for it and causing
>> hardship for those trying to debug the kernel.
>>
>
> Well, parsing kernel cmdline by systemd is a bad idea, and hiding
> "debug" is even worse. What will happen when the next keyword clashes?
> And how should I check the kernel is booted with "debug"?
>
> If there is a real need to pass arguments to systemd, how about a
> dedicated option (initargs= or whatever, where it has to be last in
> cmdline), then systemd would be spawned with these arguments and would
> just go over its argv.
>

What if systemd only parsed kernel command line arguments of the form:

...  systemd.arg_foo systemd.arg_bar=x ...

Then it wouldn't get confused by arguments that weren't directly 
targeted at it.

There is precedence for this form, as it is what we already use for 
built-in modules.  As a bonus, we would be ready for when systemd is 
integrated into the kernel as a module itself.

Thanks,
David Daney
