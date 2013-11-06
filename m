Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3KFBr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:47:56 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:35402 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab3KFBrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:47:55 -0500
Message-ID: <52799FC5.5040408@hp.com>
Date: Wed, 06 Nov 2013 09:47:49 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jingbai Ma <jingbai.ma@hp.com>, ptesarik@suse.cz,
        d.hatayama@jp.fujitsu.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        bhe@redhat.com, tom.vaden@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        anderson@redhat.com, ebiederm@xmission.com
Subject: Re: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
References: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net> <20131105202631.GC4598@redhat.com>
In-Reply-To: <20131105202631.GC4598@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 04:26 AM, Vivek Goyal wrote:
> On Tue, Nov 05, 2013 at 09:45:32PM +0800, Jingbai Ma wrote:
>> This patch set intend to exclude unnecessary hugepages from vmcore dump file.
>>
>> This patch requires the kernel patch to export necessary data structures into
>> vmcore: "kexec: export hugepage data structure into vmcoreinfo"
>> http://lists.infradead.org/pipermail/kexec/2013-November/009997.html
>>
>> This patch introduce two new dump levels 32 and 64 to exclude all unused and
>> active hugepages. The level to exclude all unnecessary pages will be 127 now.
>
> Interesting. Why hugepages should be treated any differentely than normal
> pages?
>
> If user asked to filter out free page, then it should be filtered and
> it should not matter whether it is a huge page or not?

Yes, free hugepages should be filtered out with other free pages. It 
sounds reasonable.

But for active hugepages, I would offer user more choices/flexibility. 
(maybe bad).
I'm OK to filter active hugepages with other user data page.

Any other comments?


>
> Thanks
> Vivek


-- 
Thanks,
Jingbai Ma
