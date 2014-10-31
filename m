Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaJaEEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 00:04:11 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:30079 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaJaEEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 00:04:09 -0400
Message-ID: <54530A29.9070208@huawei.com>
Date: Fri, 31 Oct 2014 12:03:53 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Richard Weinberger <richard@nod.at>, <linux-mtd@lists.infradead.org>,
        <computersforpeace@gmail.com>, <dwmw2@infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: vtbl: Use ubi_eba_atomic_leb_change()
References: <1414259021-5691-1-git-send-email-richard@nod.at> <1414659349.23185.27.camel@sauron.fi.intel.com>
In-Reply-To: <1414659349.23185.27.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.54530A37.01F8,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: d96bcaa1dd1b9841dad826cb5fab480a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/30 16:55, Artem Bityutskiy wrote:
> On Sat, 2014-10-25 at 19:43 +0200, Richard Weinberger wrote:
>> This is more a cosmetic change than a fix.
>> By using ubi_eba_atomic_leb_change()
>> we can guarantee that the first VTBL record is always
>> correct and we don't really need the second one anymore.
>> But we have to keep the second one to not break anything.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Yeah, this atomic change stuff was added later, and we had not
> envisioned originally. Your patch adds robustness, but makes volume
> creation slower, which is probably not a problem.
> 
> I've added a small comment and pushed it, thanks!
> 
> Artem
> 
> 

Hi Artem and Richard,

We are using atomic operation, leb_change(), for master_node
in ubifs-level. We use two lebs for master_node even if they
are changed with atomic operation.

I think volume_table and master_node play similar roles. Do
you think changing VTBL record into one peb is OK? I just
what to know if I missed something. Could you please take
some time to explain that?

Thanks very much~!

Hu


