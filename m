Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3G3CH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:07:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:39055 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3G3CH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:07:57 -0400
Message-ID: <51F71FBC.6030600@huawei.com>
Date: Tue, 30 Jul 2013 10:06:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andy Whitcroft <apw@canonical.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch error on trace events macros
References: <20130729195201.GC14883@xanatos> <51F7171C.4060100@huawei.com> <1375149538.2075.95.camel@joe-AO722>
In-Reply-To: <1375149538.2075.95.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/30 9:58, Joe Perches wrote:
> On Tue, 2013-07-30 at 09:30 +0800, Li Zefan wrote:
>> On 2013/7/30 3:52, Sarah Sharp wrote:
>>> Hi Andy and Joe,
>>>
>>> Checkpatch is complaining when code adds new trace events macros:
>>>
>>> sarah@xanatos:~/git/kernels/xhci$ git am -s ~/Maildir.fetchmail/.to-apply
>>> Applying: xhci: add traces for debug messages in xhci_address_device()
>>> ERROR: Macros with complex values should be enclosed in parenthesis
>>> #86: FILE: drivers/usb/host/xhci-trace.h:15:
>>> +#define TRACE_SYSTEM xhci-hcd
>>>
>>> ERROR: Macros with complex values should be enclosed in parenthesis
>>> #115: FILE: drivers/usb/host/xhci-trace.h:44:
>>> +#define TRACE_INCLUDE_PATH .
>>>
>>> ERROR: Macros with complex values should be enclosed in parenthesis
>>> #118: FILE: drivers/usb/host/xhci-trace.h:47:
>>> +#define TRACE_INCLUDE_FILE xhci-trace
>>>
>>> total: 3 errors, 0 warnings, 169 lines checked
>>>
>>>
>>> The macros have to be defined that way for trace events to work.
>>
>> yeah, that's true, and we always just ignore chechpatch complaints
>> when it comes to TRACE_EVENT macros.
>>
>>> Can you fix checkpatch not to complain about trace event macros?
>>>
> 
> So what are these TRACE_<FOO> defines that need
> excluding from the "complex values" check?
> 
> Anything other than 
> 
> TRACE_SYSTEM
> TRACE_INCLUDE_FILE
> TRACE_INCLUDE_PATH
> 
> ?
> 
> samples/trace_events/trace-events-sample.h
> only has those 3.
> 

Try:
  # scripts/checkpatch.pl --file include/trace/events/*

You'll see numerous errors. :)

