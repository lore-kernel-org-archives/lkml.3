Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab3HGLjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:39:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:50276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab3HGLjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:39:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,832,1367996400"; 
   d="scan'208";a="358949907"
Message-ID: <5202336C.5020707@intel.com>
Date: Wed, 07 Aug 2013 14:45:48 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V9 05/14] perf tools: tidy up sample parsing overflow
 checking
References: <1375719994-26482-1-git-send-email-adrian.hunter@intel.com> <1375719994-26482-6-git-send-email-adrian.hunter@intel.com> <87txj1ylb7.fsf@sejong.aot.lge.com> <52020314.7080708@intel.com> <87d2ppyj7z.fsf@sejong.aot.lge.com>
In-Reply-To: <87d2ppyj7z.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/13 11:54, Namhyung Kim wrote:
> On Wed, 07 Aug 2013 11:19:32 +0300, Adrian Hunter wrote:
>> On 07/08/13 11:09, Namhyung Kim wrote:
>>> On Mon,  5 Aug 2013 19:26:25 +0300, Adrian Hunter wrote:
>>>> The size of data retrieved from a sample event must be
>>>> validated to ensure it does not go past the end of the
>>>> event.  That was being done sporadically and without
>>>> considering integer overflows.
>>>
>>> Wouldn't it be great if the macro (or something) can do all three things
>>> together - checking overflow, getting current value (pointer) and
>>> advancing the array to the size?  Is that possible?
>>
>> Macros are not the answer to everything.
> 
> Right.
> 
> But I was seeing repeating patterns of the three.. so I asked if there's
> a better alternative.

This patch fixes bugs.  Changing the code layout is a separate patch.  I am
not going to do that.

