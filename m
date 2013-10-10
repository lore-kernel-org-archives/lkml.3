Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3JJHHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:07:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48293 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3JJHHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:07:06 -0400
X-IronPort-AV: E=Sophos;i="4.93,465,1378828800"; 
   d="scan'208";a="8710234"
Message-ID: <525651D6.3040202@cn.fujitsu.com>
Date: Thu, 10 Oct 2013 15:05:58 +0800
From: chai wen <chaiw.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, pbonzini@redhat.com, tangchen@cn.fujitsu.com,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC/query] kvm async_pf anon pined pages migration
References: <1380535387-26237-1-git-send-email-chaiw.fnst@cn.fujitsu.com> <20130930125158.GA11993@redhat.com> <BLU0-SMTP3062A22F7A685B9214BB05AE0150@phx.gbl> <5253AD0E.6060209@cn.fujitsu.com> <20131008073914.GA3574@redhat.com>
In-Reply-To: <20131008073914.GA3574@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/10 15:04:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/10 15:04:56,
	Serialize complete at 2013/10/10 15:04:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 03:39 PM, Gleb Natapov wrote:
> On Tue, Oct 08, 2013 at 02:58:22PM +0800, chai wen wrote:
>> On 10/02/2013 12:04 AM, chaiwen wrote:
>>> On 09/30/2013 08:51 PM, Gleb Natapov wrote:
>>>> On Mon, Sep 30, 2013 at 06:03:07PM +0800, chai wen wrote:
>>>>> Hi all
>>>>>
>>>>> Async page fault in kvm currently pin user pages via get_user_pages.
>>>>> when doing page migration,the method can be found via
>>>>> page->mmapping->a_ops->migratepage to offline old pages and migrate to
>>>>> new pages. As to anonymous page there is no file mapping but a anon_vma.So
>>>>> the migration will fall back to some *default* migration method.Anon pages
>>>>> that have been pined in memory by some reasons could be failed in the migration
>>>>> processing because of some reasons like ref-count checking.
>>>>> (or I misunderstand some thing?)
>>>>>
>>>>> Now we want to make these anon pages in async_pf can be migrated, I try some
>>>>> ways.But there are still many problems. The following is one that replaceing
>>>>> the mapping of anon page arbitrarily and doing some thing based on it.
>>>>> Kvm-based virtual machine can works on this patch,but have no experience of
>>>>> offline pages because of the limitaion of resouces.I'll check it later.
>>>>>
>>>>> I don't know weather it is a right direction of this issue.
>>>>> All comments/criticize are welcomed.
>>>> The pinning is not mandatory and can (and probably should) be dropped, but
>>>> pinning that is done by async page faults is short lived. What problems
>>>> are you seeing that warrant the complexity of handling their migration?
>> Hi Gleb
>>
>> As to this issue, I still have some thing not very clear.
>> If pages pinning is successfully holding (although not mandatory) by
>> async page fault.
>> And at the same time page migration happens because of memory
>> hot-remove action.
>> It has 120*hz timeout setting in common page offline processing,
>> could it fail with
>> these async_pf pined pages migration ?
>> What's your opinion about this ?   If it may fail under this
>> circumstance, should we do
>> some thing on it ?
>>
> 120 seconds is more than enough time for pinning to go away, but as I
> said the pinning is not even necessary. Patch to remove it is welcomed.
Thank you for your clarification !  I've got it. we will still work on it.

>
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Regards

chai wen

