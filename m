Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaCFJ5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:57:45 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:27787 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaCFJ5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:57:43 -0500
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/4] tile/perf: Support perf_events on tilegx and tilepro
Thread-Topic: [PATCH 3/4] tile/perf: Support perf_events on tilegx and
 tilepro
Thread-Index: Ac85BPfGeEoTjziCS5uB2wbN7ll6BgAQFy2AAAjjSmA=
Date: Thu, 6 Mar 2014 09:57:31 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D67FFB1@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C5D67FF3E@USMAExch1.tad.internal.tilera.com>
 <20140306090655.GF9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140306090655.GF9987@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Thursday, March 06, 2014 5:07 PM
>To: Tony Lu
>Cc: Paul Mackerras; Ingo Molnar; Arnaldo Carvalho de Melo; Chris Metcalf;
>linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 3/4] tile/perf: Support perf_events on tilegx and tilepro
>
>On Thu, Mar 06, 2014 at 06:26:11AM +0000, Tony Lu wrote:
>> +static const int tile_cache_event_map[PERF_COUNT_HW_CACHE_MAX]
>> +                                    [PERF_COUNT_HW_CACHE_OP_MAX]
>> +                                    [PERF_COUNT_HW_CACHE_RESULT_MAX] = {
>> +[C(L1D)] = {
>> +       [C(OP_READ)] = {
>> +               [C(RESULT_ACCESS)] = TILE_OP_UNSUPP,
>> +               [C(RESULT_MISS)] = 0x21, /* RD_MISS */
>> +       },
>> +       [C(OP_WRITE)] = {
>> +               [C(RESULT_ACCESS)] = 0x22, /* WR_MISS */
>> +               [C(RESULT_MISS)] = TILE_OP_UNSUPP,
>> +       },
>
>If that's the wr_miss event as the comment says, it should probably be
>listed one down.

Yes, you are right. Thanks for pointing it out. It should be:
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)] = TILE_OP_UNSUPP,
+		[C(RESULT_MISS)] = 0x22, /* WR_MISS */
+	},

