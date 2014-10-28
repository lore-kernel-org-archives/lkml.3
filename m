Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaJ1Mtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:49:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaJ1Mti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:49:38 -0400
Message-ID: <544F90B1.1070102@redhat.com>
Date: Tue, 28 Oct 2014 08:48:49 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com,
        linux-doc@vger.kernel.org, kexec@lists.infradead.org,
        linux-api@vger.kernel.org, jason.wessel@windriver.com
Subject: Re: [PATCH V4] kernel, add bug_on_warn
References: <1414155207-29839-1-git-send-email-prarit@redhat.com> <20141028121636.GC3274@tassilo.jf.intel.com> <544F8A78.9070008@redhat.com> <20141028122900.GA10632@redhat.com> <20141028124425.GD3274@tassilo.jf.intel.com>
In-Reply-To: <20141028124425.GD3274@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/28/2014 08:44 AM, Andi Kleen wrote:
>>> I suppose ... but that would mean I would have to explain to an end user the
>>> elaborate process of enabling kdb, inserting a break point, etc.  The whole
>>> purpose of this is to let an end user panic on WARN() easily.
>>>
>>> Asking an end user to enable kdb is magnitudes worse than asking them to
>>> recompile a kernel.
>>
>> Agreed. Asking a customer to setup and run kdb and put breakpoints is much
>> more pain than simply asking to reboot kernel with a command line option.
> 
> If you have a command line option to execute kdb commands you still
> would only have a command line option, just a slightly longer one.
> 
> kdb="on, bp warn_slowpath_common sr c, go" 

KDB is not on all kernels.  This would require me to go to great lengths to
explain to a user how to set it up, etc., rather than saying "Hi, please add
panic_on_warn as a kernel parameter/echo 1 into /proc/sys/kernel/panic_on_warn
and on the next time you see that WARN() the system will panic and kdump.  Send
me that kdump."

> 
> But it would be a generic facility instead of a special purpose hack.

Generic to KDB be configured on and it is in no way trivial to use.

P.
