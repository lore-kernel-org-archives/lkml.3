Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbaLZBUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 20:20:16 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:59294 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLZBUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 20:20:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141225220830.GA8719@krava>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-5-git-send-email-namhyung@kernel.org> <20141225220830.GA8719@krava>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 26 Dec 2014 10:19:49 +0900
X-Google-Sender-Auth: GOPZIGWwTcedtVj-U_3LKE2hCvM
Message-ID: <CAM9d7cg7TM5qEGDMbgEFVsHVc7jySckz1Q421Ok-nyiX9N1bZg@mail.gmail.com>
Subject: Re: [PATCH 04/37] perf tools: Add multi file interface to perf_data_file
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, Dec 26, 2014 at 7:08 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Dec 24, 2014 at 04:15:00PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>  #endif /* __PERF_DATA_H */
>> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
>> index d5eab3f3323f..a5046d52e311 100644
>> --- a/tools/perf/util/util.c
>> +++ b/tools/perf/util/util.c
>> @@ -72,6 +72,49 @@ int mkdir_p(char *path, mode_t mode)
>>       return (stat(path, &st) && mkdir(path, mode)) ? -1 : 0;
>>  }
>>
>> +int rm_rf(char *path)
>> +{
>> +     DIR *dir;
>> +     int ret = 0;
>> +     struct dirent *d;
>> +     char namebuf[PATH_MAX];
>> +
>> +     dir = opendir(path);
>> +     if (dir == NULL)
>> +             return 0;
>> +
>> +     while ((d = readdir(dir)) != NULL && !ret) {
>> +             struct stat statbuf;
>> +
>> +             if (d->d_name[0] == '.')
>> +                     continue;
>
> Could you check for '.' and for '..' to support '.*' removal?
>
> I know tha we will probably not have any '.*' files in perf.data.dir,
> but this function could be used later like for total cache clean ;-)

Ah, okay.


> also please submit 'rm_rf' in separate patch

Will do.


Thanks,
Namhyung
