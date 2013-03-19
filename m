Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997Ab3CSV1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:27:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:25918 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890Ab3CSV1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:27:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,874,1355126400"; 
   d="scan'208";a="273238324"
Message-ID: <5148D84A.3090604@linux.intel.com>
Date: Tue, 19 Mar 2013 14:27:38 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing: syscall_regfunc() should not skip kernel
 threads
References: <1363548972.25967.137.camel@gandalf.local.home>  <20130317182834.GA22989@redhat.com>  <1363546493.25967.129.camel@gandalf.local.home>  <20130317190438.GA24582@redhat.com>  <32387.1363705826@warthog.procyon.org.uk> <1363707396.5938.32.camel@gandalf.local.home>
In-Reply-To: <1363707396.5938.32.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 08:36 AM, Steven Rostedt wrote:
> On Tue, 2013-03-19 at 15:10 +0000, David Howells wrote:
>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>> Why? If we remove the tracepoint from the slowpath and use a table swap,
>>> then we wouldn't need to use the slowpath at all.
>>
>> How are you engineering a table swap?  Do you patch the system call code to
>> change the immediate address loaded or do you put in a level of indirection?
> 
> Patching the call site would probably be the easiest method.
> 
> We've gotten pretty good at doing that ;-)
> 

Yes, given that the machinery is already there we might as well use it.

	-hpa


