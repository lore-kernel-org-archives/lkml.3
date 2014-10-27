Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaJ0SQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:16:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbaJ0SP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:15:59 -0400
Message-ID: <544E8BB8.8000707@redhat.com>
Date: Mon, 27 Oct 2014 14:15:20 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Jason Baron <jbaron@akamai.com>
CC: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, vgoyal@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-api@vger.kernel.org
Subject: Re: [PATCH V4] kernel, add bug_on_warn
References: <1414155207-29839-1-git-send-email-prarit@redhat.com> <544E8985.50203@akamai.com>
In-Reply-To: <544E8985.50203@akamai.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/27/2014 02:05 PM, Jason Baron wrote:
> Hi Prarit,
> 
> On 10/24/2014 08:53 AM, Prarit Bhargava wrote:
>> There have been several times where I have had to rebuild a kernel to
>> cause a panic when hitting a WARN() in the code in order to get a crash
>> dump from a system.  Sometimes this is easy to do, other times (such as
>> in the case of a remote admin) it is not trivial to send new images to the
>> user.panic_on_stackoverflow
>>
>> A much easier method would be a switch to change the WARN() over to a
>> BUG().  This makes debugging easier in that I can now test the actual
>> image the WARN() was seen on and I do not have to engage in remote
>> debugging.
>>
>> This patch adds a bug_on_warn kernel parameter and
>> /proc/sys/kernel/bug_on_warn calls BUG() in the warn_slowpath_common()
>> path.  The function will still print out the location of the warning.
>>
>> An example of the bug_on_warn output:
>>
>> The first line below is from the WARN_ON() to output the WARN_ON()'s location.
>> After that the new BUG() call is displayed.
>>
>>  WARNING: CPU: 27 PID: 3204 at
>> /home/rhel7/redhat/debug/dummy-module/dummy-module.c:25 init_dummy+0x28/0x30
>> [dummy_module]()
>>  bug_on_warn set, calling BUG()...
>>  ------------[ cut here ]------------
>>  kernel BUG at kernel/panic.c:434!
> 
> Seems reasonable-I'm wondering why you just don't call panic() in this
> case. The BUG() call at line '434' doesn't at anything since its just being
> called from panic.c.

Hmm ... I didn't even think about that.

> 
> So something like 'panic_on_warn' would seem to be more appropriate
> in keeping with things like 'panic_on_oops' or 'panic_on_stackoverflow'.

I like it a lot better that way too :)  I'm changing it to panic_on_warn unless
anyone has any strenuous objections.

P.

> 
> Thanks,
> 
> -Jason
> 
