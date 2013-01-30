Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3A3Lsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:48:32 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:50302 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3A3Ls3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:48:29 -0500
Message-ID: <51090809.8010801@synopsys.com>
Date: Wed, 30 Jan 2013 17:16:17 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Robert Richter <rric@kernel.org>,
        <oprofile-list@lists.sf.net>
Subject: Re: [PATCH v3 40/71] ARC: OProfile support
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com> <1359025589-22277-25-git-send-email-vgupta@synopsys.com> <5108016B.5050303@imgtec.com> <5108BEF5.6030500@synopsys.com> <5108FBFD.8080705@imgtec.com>
In-Reply-To: <5108FBFD.8080705@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 04:24 PM, James Hogan wrote:
> On 30/01/13 06:34, Vineet Gupta wrote:
>> On Tuesday 29 January 2013 10:35 PM, James Hogan wrote:
>>> Hi Vineet,
>>>
>>> You don't appear to define CONFIG_HW_PERF_EVENTS, so
>>> include/linux/oprofile.h will presumably define oprofile_perf_init as
>>> just a pr_info(...); return -ENODEV;
>>>
>>> Similarly drivers/oprofile/oprofile_perf.o doesn't seem to be being built.
>>>
>>> I'm probably missing something somewhere?
>> Not much :-)
>>
>> oprofile_arch_init() failure causes oprofile to fall back to timer based PC only
>> sampling - for coarse grained profiling. I'll soon be starting on integratign the
>> hardware counter support to both oprofile/perf.
> Okay cool. It's just slightly misleading for anybody copying the code
> that it calls oprofile_perf_init which is known never to do anything
> :-). Maybe it's worth adding a comment in there to clarify.

I think banner comment in oprofile.h for oprofile_arch_init() needs to document
that "in case it fails, oprofile switches to timer mode PC sampling".
But nevertheless it's good idea to add that clarification in my code anyways.

>  
> Reviewed-by: James Hogan <james.hogan@imgtec.com>

Thx,
-Vineet
