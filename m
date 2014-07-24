Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbaGXPq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:46:57 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:38424 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759456AbaGXPqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140724121010.GA7652@krava.brq.redhat.com>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
 <1404883694-5342-4-git-send-email-namhyung@kernel.org> <20140724121010.GA7652@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 25 Jul 2014 00:46:25 +0900
X-Google-Sender-Auth: 2K-GBAdafgaBg_ZRxnVLmai9QEs
Message-ID: <CAM9d7cgpDGub2NubuBrSh1YVz=ahE6Sb4YJpk7+sXtQASS9qFQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] perf tools: Save column length in perf_hpp_fmt
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 9:10 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Jul 09, 2014 at 02:28:11PM +0900, Namhyung Kim wrote:
>> Save column length in the hpp format and pass it to print functions.
>> This is a preparation for users to control column width in the output.
>
> SNIP
>
>> +
>> +void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists)
>> +{
>> +     int idx;
>> +
>> +     if (perf_hpp__is_sort_entry(fmt))
>> +             return perf_hpp__reset_sort_width(fmt, hists);
>> +
>> +     for (idx = 0; idx < PERF_HPP__MAX_INDEX; idx++) {
>> +             if (fmt == &perf_hpp__format[idx])
>> +                     break;
>> +     }
>> +
>> +     if (idx == PERF_HPP__MAX_INDEX)
>> +             return;
>> +
>> +     switch (idx) {
>> +     case PERF_HPP__OVERHEAD:
>> +     case PERF_HPP__OVERHEAD_SYS:
>> +     case PERF_HPP__OVERHEAD_US:
>> +     case PERF_HPP__OVERHEAD_ACC:
>> +             fmt->len = 8;
>> +             break;
>> +
>> +     case PERF_HPP__OVERHEAD_GUEST_SYS:
>> +     case PERF_HPP__OVERHEAD_GUEST_US:
>> +             fmt->len = 9;
>> +             break;
>
> just curious.. why is it 9 for guest %, while we use 8 for host?
> I understand that was the current state

It's the strlen of header - "guest sys". :)

Thanks,
Namhyung
