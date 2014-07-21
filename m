Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaGUJlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:41:11 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40838 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaGUJlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:41:09 -0400
Message-ID: <53CCE00A.6030903@linux.vnet.ibm.com>
Date: Mon, 21 Jul 2014 15:10:26 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>, Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v2 1/3] perf/sdt : Listing of SDT markers by perf
References: <20140717054826.19995.61782.stgit@hemant-fedora> <20140717055341.19995.97042.stgit@hemant-fedora> <87d2d24kui.fsf@tassilo.jf.intel.com> <87zjg3jv0v.fsf@sejong.aot.lge.com>
In-Reply-To: <87zjg3jv0v.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072109-1618-0000-0000-0000009D1CC5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi and Namhyung,

On 07/21/2014 08:08 AM, Namhyung Kim wrote:
> Hi Andi,
>
> On Fri, 18 Jul 2014 10:50:45 -0700, Andi Kleen wrote:
>> Hemant Kumar <hemant@linux.vnet.ibm.com> writes:
>>> +/*
>>> + * Finds out the libraries present in a system as shown by the command
>>> + * "ldconfig --print-cache". Uses "=>" and '/' to find out the start of a
>>> + * dso path.
>>> + */
>> This seems like a hack. How would that handle chroot, containers
>> etc. ?
> [SNIP]
>>> +/*
>>> + * Obtain the list of paths from the PATH env variable
>>> + */
>> Same as above. This probably needs to be more configurable to handle
>> more ways to find binaries.
> Agreed.  What about not to be smart?  IOW, just let users specify
> directories and/or files to be scanned.  Maybe we can use it like:
>
>    perf list sdt --scan $PATH
>
> or
>
>    perf sdt-cache --scan /lib:/lib64

Agreed, that we need to have options to add more binaries present in
directories other than the default directories.

>
> We can add some wrapper or default directory later if needed.
>
>

But wasn't the whole point of changing to this patchset was to make SDT 
events more
prominent, i.e., to display the SDTs present in the whole system?

So, what I am trying to say is that, we already have the PATH bins and 
libs' dsos, if
we need to add more, we can use :
     perf sdt-cache --scan [dir1][:dir2]...

What would you suggest we do?

-- 
Thanks,
Hemant Kumar

