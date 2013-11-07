Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3KGI5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:57:34 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:16625 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3KGI50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:57:26 -0500
Message-ID: <527B55F0.4000301@hp.com>
Date: Thu, 07 Nov 2013 16:57:20 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: "jingbai.ma@hp.com" <jingbai.ma@hp.com>, "bhe@redhat.com" <bhe@redhat.com>,
        "tom.vaden@hp.com" <tom.vaden@hp.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lisa.mitchell@hp.com" <lisa.mitchell@hp.com>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "anderson@redhat.com" <anderson@redhat.com>
Subject: Re: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
References: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net> <20131105202631.GC4598@redhat.com> <0910DD04CBD6DE4193FCF86B9C00BE971BB7A9@BPXM01GP.gisp.nec.co.jp> <20131106142350.GB23357@redhat.com>
In-Reply-To: <20131106142350.GB23357@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 10:23 PM, Vivek Goyal wrote:
> On Wed, Nov 06, 2013 at 02:21:39AM +0000, Atsushi Kumagai wrote:
>> (2013/11/06 5:27), Vivek Goyal wrote:
>>> On Tue, Nov 05, 2013 at 09:45:32PM +0800, Jingbai Ma wrote:
>>>> This patch set intend to exclude unnecessary hugepages from vmcore dump file.
>>>>
>>>> This patch requires the kernel patch to export necessary data structures into
>>>> vmcore: "kexec: export hugepage data structure into vmcoreinfo"
>>>> http://lists.infradead.org/pipermail/kexec/2013-November/009997.html
>>>>
>>>> This patch introduce two new dump levels 32 and 64 to exclude all unused and
>>>> active hugepages. The level to exclude all unnecessary pages will be 127 now.
>>>
>>> Interesting. Why hugepages should be treated any differentely than normal
>>> pages?
>>>
>>> If user asked to filter out free page, then it should be filtered and
>>> it should not matter whether it is a huge page or not?
>>
>> I'm making a RFC patch of hugepages filtering based on such policy.
>>
>> I attach the prototype version.
>> It's able to filter out also THPs, and suitable for cyclic processing
>> because it depends on mem_map and looking up it can be divided into
>> cycles. This is the same idea as page_is_buddy().
>>
>> So I think it's better.
>
> Agreed. Being able to treat hugepages in same manner as other pages
> sounds good.
>
> Jingbai, looks good to you?

It looks good to me.

My only concern is by this way, we only can exclude all hugepage 
together, but can't exclude the free hugepages only. I'm not sure if 
user need to dump out the activated hugepage only.

Kumagai-san, please correct me, if I'm wrong.



>
> Thanks
> Vivek
>
>>
>> --
>> Thanks
>> Atsushi Kumagai
>>

-- 
Thanks,
Jingbai Ma
