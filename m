Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3JHMyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:54:13 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34299 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3JHMyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:54:12 -0400
Message-ID: <5254005F.4010103@linux.vnet.ibm.com>
Date: Tue, 08 Oct 2013 18:23:51 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] Perf support to SDT markers
References: <20131007063911.11693.33624.stgit@hemant-fedora> <5253A04E.4020809@hitachi.com>
In-Reply-To: <5253A04E.4020809@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100812-0260-0000-0000-000003BF15F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 11:33 AM, Masami Hiramatsu wrote:
> Hi,

Hi Masami and thanks a lot for testing these patches.

>
> (2013/10/07 15:46), Hemant Kumar wrote:
>> This patchset helps in probing dtrace style markers(SDT) present in user space
>> applications through perf. Notes/markes are placed at important places by the
>> developers. They have a negligible overhead when not enabled. We can enable
>> them and probe at these places and find some important information like the
>> arguments' values, etc.
> Thank you for updating!
> By the way, could you rebase this series to the latest -tip kernel next time?
> It is more convenient for us to test & merge it.

Yes, I will rebase this series next time.

>
> [...]
>> - Now use perf to list the markers in the app:
>> # perf probe --markers -x ./user_app
>>
>> %user_app:foo_start
>> %user_app:fun_start
> Here, what I got.
>
> $ ./perf probe --markers -x /lib64/librt.so
> %librt:lll_futex_wake
>
> OK, it lists up markers.
>
> $ ./perf probe --markers -x ./perf
> SDT markers not present!
>    Error : Failed to find SDT markers!(-1)
>
> OK, this shows an error, INHO, it'd better show which binary doesn't have markers.

OK, will include the binary name too.

>
> $ ./perf probe --markers
> Failed to open (null)
>    Error : Failed to find SDT markers!(-1)
>
> Hmm, it's a bit odd error. It should check if there is an elf binary is specified.

Yeah, correct.

>
> $ ./perf probe --markers /lib64/librt.so
> %librt:lll_futex_wake
>
> It seems to work without -x. However, that is only when the path is started with /.
> And also the usage is not described by --help.
>
> $ ./perf probe --markers ./perf
> Semantic error :File always requires line number or lazy pattern.
>    Error: Parse Error.  (-22)
>
> So, to avoid confusion, --markers should abort without -x(--exec) option.

Yes, we can restrict action of --markers for -x option only. I thought 
of keeping the same behavior as in case of function listing but I guess 
restricting it would be better since, --markers should only be available 
in user space.

>
>> - And  then use perf probe to add a probe point :
>>
>> # perf probe -x ./user_app -a '%user_app:foo_start'
> And also, without -x, -a also exits with an odd error message.
>
> $ ./perf probe -a %libm:slowexp_p6
> Failed to open (null)
>    Error: Failed to add events. (-1)

Ok, will rectify this behavior.

>
> I'll review each patch soon.

Thanks, looking forward to that.

- Hemant

