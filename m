Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaJXDmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 23:42:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:49786 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaJXDmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 23:42:31 -0400
Message-ID: <5449C9F6.5040903@huawei.com>
Date: Fri, 24 Oct 2014 11:39:34 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>
CC: <dedekind1@gmail.com>, <ezequiel.garcia@free-electrons.com>,
        "Richard Weinberger" <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <linux-arm-msm@vger.kernel.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH V5] mtd: ubi: Extend UBI layer debug/messaging capabilities
References: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org> <5449C870.7060509@huawei.com>
In-Reply-To: <5449C870.7060509@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/24 11:33, hujianyang wrote:
> 
>> @@ -1798,15 +1803,18 @@ int ubi_thread(void *u)
>>  	int failures = 0;
>>  	struct ubi_device *ubi = u;
>>
>> -	ubi_msg("background thread \"%s\" started, PID %d",
>> +	ubi_msg(ubi, "background thread \"%s\" started, PID %d",
>>  		ubi->bgt_name, task_pid_nr(current));
>>
>>  	set_freezable();
>>  	for (;;) {
>>  		int err;
>>
>> -		if (kthread_should_stop())
>> +		if (kthread_should_stop()) {
>> +			ubi_msg(ubi, "background thread \"%s\" should stop, PID %d",
>> +				ubi->bgt_name, task_pid_nr(current));
>>  			break;
>> +		}
>>
>>  		if (try_to_freeze())
>>  			continue;

> @@ -470,8 +470,11 @@ struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor)
>  {
>  	struct ubi_wl_entry *e = NULL;
>
> -	if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1))
> +	if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1)) {
> +		ubi_warn(ubi, "Can't get peb for fastmap:anchor=%d, free_cnt=%d, reserved=%d",
> +			 anchor, ubi->free_count, ubi->beb_rsvd_pebs);
>  		goto out;
> +	}
>
>  	if (anchor)
>  		e = find_anchor_wl_entry(&ubi->free);

Sorry, one of the adding messages should be this~!

> 
>> @@ -1798,15 +1803,18 @@ int ubi_thread(void *u)
>>  	int failures = 0;
>>  	struct ubi_device *ubi = u;
>>
>> -	ubi_msg("background thread \"%s\" started, PID %d",
>> +	ubi_msg(ubi, "background thread \"%s\" started, PID %d",
>>  		ubi->bgt_name, task_pid_nr(current));
>>
>>  	set_freezable();
>>  	for (;;) {
>>  		int err;
>>
>> -		if (kthread_should_stop())
>> +		if (kthread_should_stop()) {
>> +			ubi_msg(ubi, "background thread \"%s\" should stop, PID %d",
>> +				ubi->bgt_name, task_pid_nr(current));
>>  			break;
>> +		}
>>
>>  		if (try_to_freeze())
>>  			continue;
> 
> Here are two new adding messages. Maybe a separate patch is better? Just a
> suggestion.
> 



