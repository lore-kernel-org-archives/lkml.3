Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaD2AmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:42:00 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58420 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaD2Al7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:41:59 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 2/3] perf tools: Cache dso data file descriptor
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
	<1397756352-26694-3-git-send-email-jolsa@redhat.com>
	<1398609395.1689.17.camel@leonhard>
	<20140428100133.GE1109@krava.brq.redhat.com>
	<1398690994.1724.13.camel@leonhard> <535E6C6D.7080901@gmail.com>
Date: Tue, 29 Apr 2014 09:41:57 +0900
In-Reply-To: <535E6C6D.7080901@gmail.com> (David Ahern's message of "Mon, 28
	Apr 2014 08:57:49 -0600")
Message-ID: <87d2g1otka.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 28 Apr 2014 08:57:49 -0600, David Ahern wrote:
> On 4/28/14, 7:16 AM, Namhyung Kim wrote:
>> 2014-04-28 (월), 12:01 +0200, Jiri Olsa:
>>> On Sun, Apr 27, 2014 at 11:36:35PM +0900, Namhyung Kim wrote:
>>>> 2014-04-17 (목), 19:39 +0200, Jiri Olsa:
>>>>> Keeping the data file description open for the whole life
>>>>> of the dso object.
>>>>
>>>> I suspect there might be an issue for reporting very large data file
>>>> with this approach - like open file limit?
>>>
>>> I've got as high as ~200 openned file descriptors for
>>> ~2GB data of system wide monitoring
>>>
>>> but right that could be an issue.. I wonder we could
>>> workaround this somehow, because the speed up is quite
>>> noticable
>>>
>>> how about we monitor number of openned dso file descriptor
>>> and once we cross this we close some portion of them
>>>
>>> or something along those lines ;-)
>>
>> Yeah, we'll need some way to control those eventually.
>
> Handle EMFILE failures. Find an "old" one and close it to let the new
> one succeed.

But it would make other open(), if any, fail anyway..  So I'd rather
limit the size of the dso cache to a reasonable size.

Thanks,
Namhyung
