Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbaD1O55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:57:57 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55642 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbaD1O5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:57:52 -0400
Message-ID: <535E6C6D.7080901@gmail.com>
Date: Mon, 28 Apr 2014 08:57:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 2/3] perf tools: Cache dso data file descriptor
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>	 <1397756352-26694-3-git-send-email-jolsa@redhat.com>	 <1398609395.1689.17.camel@leonhard>	 <20140428100133.GE1109@krava.brq.redhat.com> <1398690994.1724.13.camel@leonhard>
In-Reply-To: <1398690994.1724.13.camel@leonhard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/14, 7:16 AM, Namhyung Kim wrote:
> 2014-04-28 (월), 12:01 +0200, Jiri Olsa:
>> On Sun, Apr 27, 2014 at 11:36:35PM +0900, Namhyung Kim wrote:
>>> 2014-04-17 (목), 19:39 +0200, Jiri Olsa:
>>>> Keeping the data file description open for the whole life
>>>> of the dso object.
>>>
>>> I suspect there might be an issue for reporting very large data file
>>> with this approach - like open file limit?
>>
>> I've got as high as ~200 openned file descriptors for
>> ~2GB data of system wide monitoring
>>
>> but right that could be an issue.. I wonder we could
>> workaround this somehow, because the speed up is quite
>> noticable
>>
>> how about we monitor number of openned dso file descriptor
>> and once we cross this we close some portion of them
>>
>> or something along those lines ;-)
>
> Yeah, we'll need some way to control those eventually.

Handle EMFILE failures. Find an "old" one and close it to let the new 
one succeed.

David

