Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3DBPUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:20:06 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:32783 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab3DBPUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:20:05 -0400
Message-ID: <515AF720.9010809@gmail.com>
Date: Tue, 02 Apr 2013 09:20:00 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/23] perf: make cfi unwind support based on CONFIG_LIBUNWIND
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>  <1364874877-5618-10-git-send-email-dsahern@gmail.com> <1364895122.21627.94.camel@x61.thuisdomein>
In-Reply-To: <1364895122.21627.94.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/13 3:32 AM, Paul Bolle wrote:
> On Mon, 2013-04-01 at 21:54 -0600, David Ahern wrote:
>> --- a/tools/perf/Pconfig
>> +++ b/tools/perf/Pconfig
>> @@ -1,3 +1,14 @@
>> +config ARCH
>> +    string
>> +    option env="ARCH"
>
> Why does this copy init/Kconfig?
>
>> +config X86
>> +    def_bool y if ARCH = "x86"
>> +    select HAVE_CFI_UNWIND_SUPPORT
>> +
>
> Doesn't this clash with the same Kconfig symbol in arch/x86/Kconfig?

traditionally, perf has not required a kernel config to build it. The 
above grabs some symbols for a standalone perf config. I guess that's a 
question to be answered - should the kernel's config files should be 
used for perf (or a tools target in general).

Also, perf can be built outside of the kernel tree. Tying the build to 
the kernel config files would have an affect on that option.

Something to look at for the next version.

David
