Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab3COUxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:53:38 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58449 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3COUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:53:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130315203123.GA28128@kroah.com>
References: <20130315132607.GA4565@quad>
	<20130315203123.GA28128@kroah.com>
Date: Fri, 15 Mar 2013 14:53:35 -0600
Message-ID: <CAKocOOMkLwLAjF9GpbY7QFe2SvcDpWwD7Oqi213fAeu0yUaFpA@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, mingo@elte.hu,
        tglx@linutronix.de, akpm@linux-foundation.org, acme@redhat.com,
        jolsa@redhat.com, ak@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 2:31 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 15, 2013 at 02:26:07PM +0100, Stephane Eranian wrote:
>>
>> This patch fixes a kernel crash when using precise sampling (PEBS)
>> after a suspend/resume. Turns out the CPU notifier code is not invoked
>> on CPU0 (BP). Therefore, the DS_AREA (used by PEBS) is not restored properly
>> by the kernel and keeps it power-on/resume value of 0 causing any PEBS
>> measurement to crash when running on CPU0.
>>
>> The workaround is to add a hook in the actual resume code to restore
>> the DS Area MSR value. It is invoked for all CPUS. So for all but CPU0,
>> the DS_AREA will be restored twice but this is harmless.
>>
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>
> Is this needed for the 3.8 or older kernels as well?
>
> thanks,
>
> greg k-h

Just about to ask the same question. Patch applies to 3.8, 3.4, 3.2
and 3.5. But needs some massaging for 3.0. I have the kernels built,
haven't started testing yet.

-- Shuah
