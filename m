Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaESGCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:02:40 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47573 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaESGCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:02:39 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 11/20] perf report: Add -F option to specify output fields
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
	<1399876133-17963-12-git-send-email-namhyung@kernel.org>
	<20140515131717.GF25858@krava.brq.redhat.com>
	<871tvukzbp.fsf@sejong.aot.lge.com>
Date: Mon, 19 May 2014 15:02:21 +0900
In-Reply-To: <871tvukzbp.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Fri, 16 May 2014 15:33:14 +0900")
Message-ID: <87k39ijogi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 15:33:14 +0900, Namhyung Kim wrote:
> On Thu, 15 May 2014 15:17:17 +0200, Jiri Olsa wrote:
>> On Mon, May 12, 2014 at 03:28:44PM +0900, Namhyung Kim wrote:
>>
>> SNIP
>>
>>> +
>>> +int setup_output_field(void)
>>> +{
>>> +	char *tmp, *tok, *str;
>>> +	int ret = 0;
>>> +
>>> +	if (field_order == NULL)
>>> +		goto out;
>>> +
>>> +	reset_dimensions();
>>
>> Do we want to call this in setup_sorting as well? In case
>> we mix the order of setup_output_field and setup_sorting
>> in the future?
>
> Yeah, looks like a good idea.

Hmm.. I misunderstood your point.  The thing is that the initialization
step needs to be done in a specific order (due to their implicit
dependency).  So I change it to be called in one place, setup_sorting().

Thanks,
Namhyung
