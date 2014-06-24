Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaFXTDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:03:15 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50910 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaFXTDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:03:14 -0400
Message-ID: <53A9CB6E.5080104@gmail.com>
Date: Tue, 24 Jun 2014 13:03:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
        artagnon@gmail.com, rusty@rustcorp.com.au, bp@suse.de
Subject: Re: [PATCH v4 0/4] perf timechart io mode
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru> <20140624084113.GC31390@krava.redhat.com> <20140624091022.GE20225@stfomichev-desktop.yandex.net> <20140624165712.GA10114@stfomichev-desktop.yandex.net> <53A9B7A4.9050805@gmail.com> <20140624185134.GB1148@krava.brq.redhat.com>
In-Reply-To: <20140624185134.GB1148@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/14, 12:51 PM, Jiri Olsa wrote:
> On Tue, Jun 24, 2014 at 11:38:44AM -0600, David Ahern wrote:
>> On 6/24/14, 10:57 AM, Stanislav Fomichev wrote:
>>> On Tue, Jun 24, 2014 at 01:10:22PM +0400, Stanislav Fomichev wrote:
>>>>> hum, got this when trying:
>>>>>
>>>>> [jolsa@krava perf]$ sudo ./perf timechart record -I
>>>>> ^C[ perf record: Woken up 2 times to write data ]
>>>>> [ perf record: Captured and wrote 1.071 MB perf.data (~46806 samples) ]
>>>>> [jolsa@krava perf]$ ./perf timechart
>>>>> Invalid previous event (non-zero)!
>>>>> 0x113f80 [0x8]: failed to process type: 68
>>
>> I see this kind of message a lot, but typically in high event use cases
>> (e.g., 100+MB files in a run of a few seconds). I usually increase the map
>> size (-m 4096) and/or bump the priority of perf (-r1) and re-run the test.
>
> maybe we dont need to fail in this case.. seems like it should
> not be hard to detect, wanr and recover? ;-)
>

seems to me it should not be happening at all. It seems like the head 
caught the tail and was not properly detected.

David

