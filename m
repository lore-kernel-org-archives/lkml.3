Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaKHNaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:30:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbaKHNaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:30:11 -0500
Message-ID: <545E1AB1.9030001@redhat.com>
Date: Sat, 08 Nov 2014 08:29:21 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com,
        jbaron@akamai.com, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v8] kernel, add panic_on_warn
References: <1415187736-16242-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com> <545B733C.6080903@redhat.com> <alpine.DEB.2.10.1411061352440.1526@chino.kir.corp.google.com> <20141106220731.GA13590@redhat.com> <alpine.DEB.2.10.1411070214220.32405@chino.kir.corp.google.com> <545CA765.8010403@redhat.com> <alpine.DEB.2.10.1411071306370.12192@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.10.1411071306370.12192@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/2014 04:09 PM, David Rientjes wrote:
> On Fri, 7 Nov 2014, Prarit Bhargava wrote:
> 
>> There very much is.  Consider a thread that hits a WARN() and then panics.  Then
>> somewhere in the panic code the thread hits another WARN() ... and then panics
>> again.  Previously this would have caused the system to "finish" panick'ing.
>> Now it makes the system hang.
>>
> 
> Then we're back to square one which is what is obviously the intent of 
> your patch and the comment that goes along with it: 

My original reply pointed out that the comment was wrong.

we want to clear
> panic_on_warn once and not allow multiple panic().  

On _this_ thread.  The multiple panic across threads cannot occur.

So why not just add
> the necessary synchronization to make sure that happens when WARN() 
> happens on two cpus simultaneously?

See above.

P.

> 
