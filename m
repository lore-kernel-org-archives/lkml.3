Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3HZOOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:14:11 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:58771 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3HZOOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:14:09 -0400
Message-ID: <521B62AF.2030408@linux.vnet.ibm.com>
Date: Mon, 26 Aug 2013 16:14:07 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>
CC: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com
Subject: Re: [RFC PATCH 3/4] gcov: compile specific gcov implementation based
 on gcc version
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com> <1377247176-13537-4-git-send-email-fhrbata@redhat.com> <52177C87.4090003@linux.vnet.ibm.com> <52177DE8.6090704@linux.vnet.ibm.com> <20130824194413.GB2365@localhost.localdomain>
In-Reply-To: <20130824194413.GB2365@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082614-8372-0000-0000-000006FCD249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.08.2013 21:44, Frantisek Hrbata wrote:
> On Fri, Aug 23, 2013 at 05:21:12PM +0200, Peter Oberparleiter wrote:
>> On 23.08.2013 17:15, Peter Oberparleiter wrote:
>>> On 23.08.2013 10:39, Frantisek Hrbata wrote:
>>>> Compile the correct gcov implementation file for a specific gcc version. In
>>>> the future, if another file is added, the conditions will need to be somehow
>>>> adjusted to if-elif-else case, but at this point the simple cc-ifversion should
>>>> be enough.
>>
>> As promised, I'm also adding the patch that makes the format-specific part
>> of gcov-kernel a loadable kernel module:
>>
>> ---
>> kernel: gcov: make format-specific code loadable
>>
>> Turn the format-specific part of gcov-kernel into a loadable kernel
>> module. This enables the use of gcov-kernel with kernel modules
>> that were compiled with a version of GCC that produces a different
>> gcov format when compared to the version of GCC that was used to
>> compile the kernel.
> 
> If I understand it correctly, this would mean that you will be able to use only
> one implementation of gcov format at the time. Meaning you will be able to get
> coverage data for module, but not for kernel if it was compiled with different
> gcc(gcda format). This is probably ok if you work only on your module, but I'm
> not sure this is generally the right approach. In this case I would probably
> rather see some support for more gcov formats at the same time(e.g. set of
> callback operations per gcov version). Again I'm probably missing something, but
> I still cannot see reason why to add such feature. If you want gcov support just
> compile your kernel and modules with the same gcc version(gcda format). But if
> this is really needed maybe it would be better to consider some parallel support
> for more gcov formats based on the gcov_info version.

The callback approach has other drawbacks (see previous mail).

> Would it be possible to add support for the modified gcc 4.7 gcov format and
> deal with this later? I can incorporate your changes: iter to use buffer,
> .init_array for modules and possibility to explicitly select the gcda format.
> In this case we will have at least the basic support in kernel. This is just me
> thinking out loud.

I think that's an approach I can live with. Maybe the need for a multi-version
support will surface again later in a more refined form, but until then there
should be no reason to delay base GCC 4.7 support any further.


-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

