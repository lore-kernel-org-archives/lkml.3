Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3E0AOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 20:14:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44090 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3E0AOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 20:14:05 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51A2A524.4080303@jp.fujitsu.com>
Date: Mon, 27 May 2013 09:13:24 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vivek Goyal <vgoyal@redhat.com>, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v8 3/9] vmcore: treat memory chunks referenced by PT_LOAD
 program header entries in page-size boundary in vmcore_list
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6> <20130523052513.13864.85440.stgit@localhost6.localdomain6> <20130523144928.0328bb3ad7ccc1ff2da9558d@linux-foundation.org> <20130524131217.GA18218@redhat.com>
In-Reply-To: <20130524131217.GA18218@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/24 22:12), Vivek Goyal wrote:
> On Thu, May 23, 2013 at 02:49:28PM -0700, Andrew Morton wrote:
>> On Thu, 23 May 2013 14:25:13 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>>
>>> Treat memory chunks referenced by PT_LOAD program header entries in
>>> page-size boundary in vmcore_list. Formally, for each range [start,
>>> end], we set up the corresponding vmcore object in vmcore_list to
>>> [rounddown(start, PAGE_SIZE), roundup(end, PAGE_SIZE)].
>>>
>>> This change affects layout of /proc/vmcore.
>>
>> Well, changing a userspace interface is generally unacceptable because
>> it can break existing userspace code.
>>
>> If you think the risk is acceptable then please do explain why.  In
>> great detail!
>
> I think it should not be a problem as /proc/vmcore is useful only when
> one parses the elf headers and then accesses the contents of file based
> on the header information. This patch just introduces additional areas
> in /proc/vmcore file and ELF headers still point to right contents. So
> any tool parsing ELF headers and then accessing file contents based on
> that info should still be fine.
>
> AFAIK, no user space tool should be broken there.
>
> Thanks
> Vivek
>

Yes, the changes are new introduction of holes between components of ELF
and tools doesn't reach the holes as long as by looking up program header
table and other tables. cp command touches the holes but trivially works
well.

-- 
Thanks.
HATAYAMA, Daisuke

