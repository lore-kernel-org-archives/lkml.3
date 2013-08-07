Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3HGIue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:50:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47190 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab3HGIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:50:32 -0400
X-AuditID: 9c930197-b7b17ae000000a07-fa-52020a56311f
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V9 01/14] perf tools: add debug prints
References: <1375719994-26482-1-git-send-email-adrian.hunter@intel.com>
	<1375719994-26482-2-git-send-email-adrian.hunter@intel.com>
	<8738qmyp7i.fsf@sejong.aot.lge.com> <520201A3.4030606@intel.com>
Date: Wed, 07 Aug 2013 17:50:30 +0900
In-Reply-To: <520201A3.4030606@intel.com> (Adrian Hunter's message of "Wed, 07
	Aug 2013 11:13:23 +0300")
Message-ID: <87haf1yje1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Aug 2013 11:13:23 +0300, Adrian Hunter wrote:
> On 07/08/13 09:44, Namhyung Kim wrote:
>> Things like this likely being ended up with typo.  How about this? (not tested)
>
> And yet there aren't any typos.

Yes, but there's a possibility of adding one later.  I have a memory
that when Jiri added something similar there's one so we changed to use
macros for that.

>
>> 
>> #define __PRINT_ATTR(fmt, cast, field)  \
>> 	fprintf(fp, "  %-28s  "fmt"\n", #field, cast attr->field)
>> 
>> #define PRINT_ATTR_D32(field)  __PRINT_ATTR("%u", ,field)
>> #define PRINT_ATTR_X32(field)  __PRINT_ATTR("%#x", ,field)
>> #define PRINT_ATTR_D64(field)  __PRINT_ATTR("%"PRIu64, (uint64_t), field)
>> #define PRINT_ATTR_X64(field)  __PRINT_ATTR("%#"PRIx64, (uint64_t), field)
>> #define PRINT_ATTR2(field1, field2)  \
>> 	fprintf(fp, "  %-28s  %u    %-28s  %u\n", \
>> 		#field1, attr->field1, #field2, attr->field2)
>
> That does not allow the output to be nicely formatted.  In some cases the
> field name is just too long and I have abbreviated it.

But yet there aren't any longer than 28. :)

>
> When you add in all the variations you just get a macro mess.

I think above 5 is enough but who knows..

Anyway I won't arguing on it strongly, it's just a matter of styles IMHO.

Thanks,
Namhyung
