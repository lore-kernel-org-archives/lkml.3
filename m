Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab3CZSwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:52:13 -0400
Received: from fe2.lbl.gov ([128.3.41.134]:63501 "EHLO fe2.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab3CZSwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:52:12 -0400
X-Ironport-SBRS: 2.6
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AosCANLsUVHRVYDGfmdsb2JhbABDxAV+CBYOAQEJCwwIFF6CHwEBBAFyBwULCws7IhIBBQEcBoghBqMCjiOPeI8SB4NAA4h4jW+PJRYphE0c
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="14586653"
MIME-Version: 1.0
In-Reply-To: <878v63svr8.fsf@sejong.aot.lge.com>
References: <CA+BNSkX-2NhJmf0b26Bmf-bK_dFnGE_NOR-F9p2MDpZTuScHpg@mail.gmail.com>
	<878v63svr8.fsf@sejong.aot.lge.com>
Date: Tue, 26 Mar 2013 11:52:10 -0700
Message-ID: <CA+BNSkUiNyB_mpsmHa2QQMGBmG+YQ+0De2ApC1AuVRdrWFYOXw@mail.gmail.com>
Subject: Re: [PATCH] perf: add callgrind conversion tool
From: Roberto Vitillo <ravitillo@lbl.gov>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, rostedt@goodmis.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  LIB_OBJS += $(OUTPUT)ui/setup.o
>>  LIB_OBJS += $(OUTPUT)ui/helpline.o
>> @@ -528,6 +532,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
>>  BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
>>  BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
>>  BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
>> +BUILTIN_OBJS += $(OUTPUT)builtin-convert.o
>
> You can make these conditional after checking availibility of bfd.
Ok

> AFAICS this cg_cnv_sample() does nothing with converting.  Why did you
> move the code to a different file rather than keeping it together?
Good point, there isn't really a good reason to have this in a separate file.

> The name of the function doesn't look good to me.  Maybe hists__convert_symbols?
Agreed, it's confusing.

>> +     /* Needed to display correctly the inlining relationship in kcachegrind */
>> +     if (ret_caller && caller_line)
>> +             fprintf(output, "fl=%s\n0 0\n", caller_name);
>> +
>> +     if (ret_callee && last_line)
>> +             fprintf(output, "fl=%s\n", last_source_name);
>> +     else
>> +             fprintf(output, "fl=\n");
>
> Could you explain why this empty fl line is needed?
Without the empty fl statement kcachegrind would apply the last valid fl
statement in the file.

Thanks,
Roberto
