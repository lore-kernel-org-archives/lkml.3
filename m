Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3FNIWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:22:44 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2562 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3FNIWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:22:41 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51BAD2C4.3080904@broadcom.com>
Date: Fri, 14 Jun 2013 10:22:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tom Zanussi" <tom.zanussi@intel.com>,
        "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>
Subject: Re: event filtering with trace-cmd
References: <51B849BA.6000802@broadcom.com>
 <1371054120.9844.259.camel@gandalf.local.home>
 <1371057385.9844.261.camel@gandalf.local.home>
In-Reply-To: <1371057385.9844.261.camel@gandalf.local.home>
X-WSS-ID: 7DA40F222L833138255-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 07:16 PM, Steven Rostedt wrote:
> On Wed, 2013-06-12 at 12:22 -0400, Steven Rostedt wrote:
>
>>> # sudo trace-cmd record -e brcmfmac:brcmf_dbg -f 'level & 0x40000'
>>> disable all
>>> enable brcmfmac:brcmf_dbg
>>> path = /sys/kernel/debug/tracing/events/brcmfmac/brcmf_dbg/enable
>>> (level & 0x40000)
>>> ^
>>> parse_error: Invalid operator
>>>
>>
>> The record -f command passes the filter into the kernel
>> file /sys/kerne/debug/tracing/events/brcmfmac/brcmf_dbg/filter, and the
>> error is actually coming from the kernel itself. Looking at the code, we
>> do not currently accept binary operations. Although, it shouldn't be too
>> hard to add. I may go and implement it for 3.11.
>>
>
> Here, can you apply this patch and see if it does what you expect?

Hi Steven,

That patch does exactly what I expect. Thanks.

Regards,
Arend

