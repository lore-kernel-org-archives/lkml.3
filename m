Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaJ1MW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:22:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbaJ1MWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:22:54 -0400
Message-ID: <544F8A78.9070008@redhat.com>
Date: Tue, 28 Oct 2014 08:22:16 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, vgoyal@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-api@vger.kernel.org,
        jason.wessel@windriver.com
Subject: Re: [PATCH V4] kernel, add bug_on_warn
References: <1414155207-29839-1-git-send-email-prarit@redhat.com> <20141028121636.GC3274@tassilo.jf.intel.com>
In-Reply-To: <20141028121636.GC3274@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/28/2014 08:16 AM, Andi Kleen wrote:
> On Fri, Oct 24, 2014 at 08:53:27AM -0400, Prarit Bhargava wrote:
>> There have been several times where I have had to rebuild a kernel to
>> cause a panic when hitting a WARN() in the code in order to get a crash
>> dump from a system.  Sometimes this is easy to do, other times (such as
>> in the case of a remote admin) it is not trivial to send new images to the
>> user.
>>
>> A much easier method would be a switch to change the WARN() over to a
>> BUG().  This makes debugging easier in that I can now test the actual
>> image the WARN() was seen on and I do not have to engage in remote
>> debugging.
> 
> IMHO this would be better and far more generically done with kdb. 
> You would need two things:
> 
> - Extend the break point command to run another command on a break point.
> - Add a command line (or possibly /proc) option to execute some kdb commands at
> kernel boot.

I suppose ... but that would mean I would have to explain to an end user the
elaborate process of enabling kdb, inserting a break point, etc.  The whole
purpose of this is to let an end user panic on WARN() easily.

Asking an end user to enable kdb is magnitudes worse than asking them to
recompile a kernel.

P.

> 
> Then just set a break point on the warn function and execute magic sysrq c
> from kdb.
> 
> -Andi
> 
