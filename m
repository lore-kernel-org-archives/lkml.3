Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3KRBAD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 20:00:03 -0500
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:62773 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab3KRA7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 19:59:55 -0500
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: "vgoyal@redhat.com" <vgoyal@redhat.com>
CC: "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "chaowang@redhat.com" <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
Thread-Topic: /proc/vmcore mmap() failure issue
Thread-Index: AQHO4SSy18hsX/7760SqeZbh92xDyw==
Date: Mon, 18 Nov 2013 00:51:39 +0000
Message-ID: <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp>
References: <20131113204130.GD7613@redhat.com>
 <5284A689.70903@jp.fujitsu.com> <20131114151359.GA3913@redhat.com>
 <5285EC60.1060906@jp.fujitsu.com> <20131115142617.GC6637@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.40.240]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/15 23:26), Vivek Goyal wrote:
> On Fri, Nov 15, 2013 at 06:41:52PM +0900, HATAYAMA Daisuke wrote:
>
> [..]
>>> Given the fact that hpa does not like fixing it in kernel. We are left
>>> with option of fixing it in following places.
>>>
>>> - Drop partial pages in kexec-tools
>>> - Drop partial pages in makeudmpfile.
>>> - Read partial pages using read() interface in makedumpfile
>>> - Modify /proc/vmcore to copy partial pages in second kernel's memory.
>>>
>>> It is not clear to me that partial pages are really useful.  So I want
>>> to avoid modifying /proc/vmcore to deal with partial pages and increase
>>> complexity.
>>>
>>> So fixing makedumpfile (either option2 or option 3) seems least risky
>>> to me. In fact I would say let us keep it simple and truncate partial
>>> pages in makedumpfile to keep it simple. And look at option 3 once we
>>> have a strong use case for partial pages.
>>>
>>> What do you think?
>>>
>>
>> As you say, it's not clear that partial pages are really useful, but on
>> the other hand, it seems to me not clear that they are really useless.
>> I think we should get them as long as we have access to them.
>>
>> It seems best to me the option 3). Switching between read and mmap would
>> be not so complex and also it's by far flexible in makedumpfile than in
>> kernel.
>
> Ok, I am fine with option 3. It is more complicated option but safe
> option.

It sounds reasonable also to me.

> Is there any chance that you could look into fixing this. I have no
> experience writing code for makedumpfile.

I'll send a patch to fix this soon.


Thanks
Atsushi Kumagai
