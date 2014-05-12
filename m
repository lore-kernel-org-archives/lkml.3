Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbaELMuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:50:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44641 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaELMuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:50:13 -0400
Message-ID: <5370C380.6010103@suse.cz>
Date: Mon, 12 May 2014 14:50:08 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 04/16] kgr: add testing kgraft patch
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz> <1398868249-26169-5-git-send-email-jslaby@suse.cz> <20140506110318.GB15033@xo-6d-61-c0.localdomain>
In-Reply-To: <20140506110318.GB15033@xo-6d-61-c0.localdomain>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 01:03 PM, Pavel Machek wrote:
> Hi!

Hi!

>> This is intended to be a presentation of the kgraft engine, so it is
>> placed into samples/ directory.
>>
>> It patches sys_iopl() and sys_capable() to print an additional message
>> to the original functionality.
>>
>> Jiri Kosina <jkosina@suse.cz>
> 
> ??

This was a messed up s-o-b line. Fixed already.

>> +KGR_PATCHED_FUNCTION(patch, SyS_iopl, kgr_new_sys_iopl);
>> +
>> +static bool new_capable(int cap)
>> +{
>> +	printk(KERN_DEBUG "kgr-patcher: this is a new capable()\n");
>> +
>> +        return ns_capable(&init_user_ns, cap);
>> +}
>> +KGR_PATCHED_FUNCTION(patch, capable, new_capable);
> 
> So for some reason when replacing sys_iopl, capable needs to be replaced, too?

Oh, no. This patch just demonstrates how to patch two functions at once.
They were chosen arbitrarily.

The rest has been fixed now.

thanks,
-- 
js
suse labs
