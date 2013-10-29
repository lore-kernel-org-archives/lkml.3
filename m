Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab3J2Tlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:41:35 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49205 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3J2Tle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:41:34 -0400
Message-ID: <52700F66.8080105@linux.vnet.ibm.com>
Date: Wed, 30 Oct 2013 01:11:26 +0530
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Pekka Enberg <penberg@iki.fi>
CC: David Ahern <dsahern@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "hegdevasant@linux.vnet.ibm.com" <hegdevasant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "anton@redhat.com" <anton@redhat.com>,
        "systemtap@sourceware.org" <systemtap@sourceware.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "aravinda@linux.vnet.ibm.com" <aravinda@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com> <F53BA283-A194-4057-8409-27FD3ECFDF2E@iki.fi> <526A8C2B.7000401@gmail.com> <526E24EA.2040701@iki.fi> <526E9808.4030607@gmail.com> <526EB0C3.2080304@iki.fi> <526F862E.9060203@linux.vnet.ibm.com> <526FC0B2.6060206@iki.fi>
In-Reply-To: <526FC0B2.6060206@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102919-9574-0000-0000-00000A57124A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 07:35 PM, Pekka Enberg wrote:
> On 10/29/2013 11:55 AM, Hemant Kumar wrote:
>> 1. Where this cache should be? Keeping it in tracing directory inside 
>> the debugfs
>> directory should seem more feasible. And, shall this cache be shareable?
>
> You can't share all of the cache because otherwise you'll expose 
> details on binaries that not everyone has access to.

Correct, that was one of the reason to be worried. And since, to a 
normal user debugfs is not allowed to be entered, then we can keep that 
inside debugfs/tracing subdirectory.

>
> It might make sense to split the cache into two parts: system markers 
> and user markers and share the former.
>

Ok...

>> 2. perf record is a performance intensive process, can we allow the 
>> delay due to
>> this searching process here?
>
> I think scanning is OK if the user specified a SDT markers but not 
> otherwise.
>
> Perhaps you can use a bloom filter to quickly check if the user passed 
> a SDT marker or not.
>

True, bloom filters may help in this case with a quick check.

-- 
Thanks
Hemant Kumar

