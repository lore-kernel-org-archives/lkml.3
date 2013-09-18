Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3IRN6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:58:30 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39768 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3IRN63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130918132903.GA4071@gmail.com>
References: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
 <20130918092444.GA2778@gmail.com> <CAPybu_2GBymhgxHmtJu63pT2t8ge84EA9Ww54r9mGOA5KH7Hww@mail.gmail.com>
 <CAPybu_2Wf_p-jo2X4VzSBXrfy3DnHY4PeOvNVLfeoGRFfbDwRA@mail.gmail.com>
 <20130918101801.GO12926@twins.programming.kicks-ass.net> <20130918130735.GC2240@ghostprotocols.net>
 <20130918132903.GA4071@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 18 Sep 2013 15:58:08 +0200
Message-ID: <CAPybu_0CECKhPqpCpQoVvkUoWH-U6NqWfbVc3HjSvP_j6L_V3A@mail.gmail.com>
Subject: Re: [PATCH] perf: Support for Openembedded/Yocto -dbg packages
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo Arnaldo and Peter

I have just posted v3,

Thanks for your comments!

On Wed, Sep 18, 2013 at 3:29 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
>
>> Em Wed, Sep 18, 2013 at 12:18:01PM +0200, Peter Zijlstra escreveu:
>> > On Wed, Sep 18, 2013 at 12:02:12PM +0200, Ricardo Ribalda Delgado wrote:
>> > > Perhaps this is even more clear than v2:
>>
>> > > len = snprintf(file, size, "%s", symbol_conf.symfs);
>> > > size -= len;
>> > > file += len;
>> > > len = snprintf(file, MIN(size,(last_slash - dso->long_name) + 2),
>> > > "%s",  dso->long_name);
>> > > size -= len;
>> > > file += len;
>> > > len = snprintf(file, size, ".debug%s",  last_slash);
>>
>> > len = 0;
>>
>> > len += snprintf(str + len, size - len, ...);
>> > len += snprintf(str + len, size - len, ...);
>>
>> And avoid snprintf like the plague, use scnprintf instead...  See
>> e7f01d1e3d8d501deb8abeaa269d5d48a703b8b0 for details :-)
>
> Hm, could we do:
>
>         #define snprintf scnprintf
>
> or:
>
>         #define snprintf(x...) BUILD_BUG()
>
> ?
>
> I don't think there's any valid code, except printf wrappers (which we
> don't have in perf), where the semantics of snprintf() would be needed.
>
> Thanks,
>
>         Ingo



-- 
Ricardo Ribalda
