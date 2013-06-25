Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3FYFG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:06:26 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50875 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3FYFGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:06:24 -0400
Message-ID: <51C92636.2060006@linux.vnet.ibm.com>
Date: Tue, 25 Jun 2013 10:40:14 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
        Jens Axboe <axboe@kernel.dk>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        Lin Ming <ming.m.lin@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block:Remove extra condition in end of disk check
References: <20130623171711.7127.16248.sendpatchset@codeblue.in.ibm.com> <51C84E94.8020100@linux.vnet.ibm.com> <20130624225126.GO1918@mtj.dyndns.org>
In-Reply-To: <20130624225126.GO1918@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062504-2000-0000-0000-00000CA001D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 04:21 AM, Tejun Heo wrote:
> On Mon, Jun 24, 2013 at 07:20:12PM +0530, Raghavendra K T wrote:
>>> @@ -1656,7 +1656,7 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
>>>   	if (maxsector) {
>>>   		sector_t sector = bio->bi_sector;
>>>
>>> -		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
>>> +		if (maxsector - nr_sectors < sector) {
>
> If maxsector < nr_sectors, the subtraction will underflow making it a
> very large number and fail to detect the invalid condition, no?
>

Hi Tejun,
Thanks for the reply and explanation. You are right. underflow results
in invalid condition.

Considering maxsector and sectors are unsigned long, and nr_sector is
unsigned int, probably safer bet is
(max_sector < sector + nr_sector), but still it would leave scope for 
overflow.

Thanks again,
Raghu.

