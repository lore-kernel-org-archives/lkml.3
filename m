Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3H1IyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:54:21 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49467 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3H1IyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:54:19 -0400
Message-ID: <521DBAB1.3080600@linux.vnet.ibm.com>
Date: Wed, 28 Aug 2013 16:54:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 08/12] KVM: MMU: introduce nulls desc
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130828084009.GO22899@redhat.com>
In-Reply-To: <20130828084009.GO22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082808-2674-0000-0000-00000A69AC0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 04:40 PM, Gleb Natapov wrote:

>>  static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
>> @@ -1200,7 +1221,7 @@ static u64 *rmap_get_first(unsigned long rmap, struct rmap_iterator *iter)
>>   */
>>  static u64 *rmap_get_next(struct rmap_iterator *iter)
>>  {
>> -	if (iter->desc) {
>> +	if (iter->desc && !desc_is_a_nulls(iter->desc)) {
>>  		if (iter->pos < PTE_LIST_EXT - 1) {
>>  			u64 *sptep;
>>  
>> @@ -1212,7 +1233,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
>>  
>>  		iter->desc = iter->desc->more;
>>  
> I'd rather do:
> 		iter->desc = desc_is_a_nulls(iter->desc) ? NULL : iter->desc;
> here and drop two desc_is_a_nulls() checks in this function.

Nice, will do it in the next version. Thanks!

