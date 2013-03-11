Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3CKISH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:18:07 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:36239 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3CKISF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:18:05 -0400
Message-ID: <513D9338.20402@hp.com>
Date: Mon, 11 Mar 2013 16:18:00 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Jingbai Ma <jingbai.ma@hp.com>, mingo@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, hpa@zytor.com, yinghai@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net> <20130307152108.GC2790@redhat.com> <87k3piri3e.fsf@xmission.com> <20130308155216.GB8219@redhat.com>
In-Reply-To: <20130308155216.GB8219@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 11:52 PM, Vivek Goyal wrote:
> On Thu, Mar 07, 2013 at 01:54:45PM -0800, Eric W. Biederman wrote:
>> Vivek Goyal<vgoyal@redhat.com>  writes:
>>
>>> On Thu, Mar 07, 2013 at 10:58:18PM +0800, Jingbai Ma wrote:
>>>> This patch intend to speedup the memory pages scanning process in
>>>> selective dump mode.
>>>>
>>>> Test result (On HP ProLiant DL980 G7 with 1TB RAM, makedumpfile
>>>> v1.5.3):
>>>>
>>>> 						Total scan Time
>>>> Original kernel
>>>> 	+ makedumpfile v1.5.3 cyclic mode	1958.05 seconds
>>>> Original kernel
>>>> 	+ makedumpfile v1.5.3 non-cyclic mode	1151.50 seconds
>>>> Patched kernel
>>>> 	+ patched makedumpfile v1.5.3		17.50 seconds
>>>>
>>>> Traditionally, to reduce the size of dump file, dumper scans all memory
>>>> pages to exclude the unnecessary memory pages after capture kernel
>>>> booted, and scan it in userspace code (makedumpfile).
>>>
>>> I think this is not a good idea. It has several issues.
>>
>> Actually it does not appear to be doing any work in the first kernel.
>
> Looks like patch3 in series is doing that.
>
>                          machine_crash_shutdown(&fixed_regs);
> +                       generate_crash_dump_bitmap();
>                          machine_kexec(kexec_crash_image);
>
> So this bitmap seems to be being set just before transitioning into
> second kernel.
>
> I am sure you would not like this extra code in this path. :-)

I was thought this function code is pretty simple, could be called here 
safely.
If it's not proper for here, how about before the function 
machine_crash_shutdown(&fixed_regs)?
Furthermore, could you explain the real risks to execute more codes here?

Thanks!

>
> Thanks
> Vivek


-- 
Jingbai Ma (jingbai.ma@hp.com)
