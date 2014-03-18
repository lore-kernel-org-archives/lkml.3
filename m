Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaCRO1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:27:17 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35470 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbaCRO1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140318132355.GA7845@krava.brq.redhat.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
 <1395095198-20034-6-git-send-email-artagnon@gmail.com> <878us8rkqq.fsf@sejong.aot.lge.com>
 <20140318132355.GA7845@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 18 Mar 2014 23:26:53 +0900
X-Google-Sender-Auth: 8saPLjuNKJMohOv336pIhVJwIqs
Message-ID: <CAM9d7ciRP17_YV5dtrphWKEXEzOTy7XQw7tG13oVs5RV3XzcYg@mail.gmail.com>
Subject: Re: [PATCH 5/5] perf test: squelch warnings about undefined sizeof
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Mar 18, 2014 at 10:23 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Mar 18, 2014 at 05:09:33PM +0900, Namhyung Kim wrote:
>> On Mon, 17 Mar 2014 18:26:38 -0400, Ramkumar Ramachandra wrote:
>> > perf test emits the following warnings on the parse events test:
>> >
>> >   $ perf test
>> >    5: parse events tests
>> >     Warning: function sizeof not defined
>> >     Warning: function sizeof not defined
>> >     Warning: function sizeof not defined
>> >     Warning: function sizeof not defined
>> >     Warning: function sizeof not defined
>> >     Warning: function sizeof not defined
>> >     Warning: function sizeof not defined
>> >     Warning: function sizeof not defined
>> >     ...
>> >
>> > Squelch the warnings by explicitly ignoring the sizeof function.
>>
>> It just hides the warning leaving the real problem untouched.  If you
>> really don't want to see those, I guess installing proper plugin for the
>> failing events will help you (in case you didn't).
>
> it wont' help, sizeof is special.. AFAIK we did not figure
> out a way to handle that so far
>
> but I think it was used only in one trace subsystem.. maybe we
> could replace it and forbid to use it in future ;-)

Yep, I know.  But I meant that if we have a handler for the failing
event, it might print the event without even using the sizeof somehow.
;-)

Thanks,
Namhyung
