Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892AbaLORMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:12:43 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:44512 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLORMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:12:40 -0500
Message-ID: <548F1686.4080507@lwfinger.net>
Date: Mon, 15 Dec 2014 11:12:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Karthik Nayak <karthik.188@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] Staging: rtl8712: removed an unnecessary else statement
References: <1418657154-10481-1-git-send-email-karthik.188@gmail.com> <1418661543.2674.17.camel@perches.com>
In-Reply-To: <1418661543.2674.17.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 10:39 AM, Joe Perches wrote:
> On Mon, 2014-12-15 at 20:55 +0530, Karthik Nayak wrote:
>> As per checkpatch warning, removed an unnecessary else statement
>> proceeding an if statement with a return.
>
> This is not a correct change.
> The checkpatch message said "generally".
> You still have to verify the code.
>
>> diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
>> index cd8b444..800b2b3 100644
>> --- a/drivers/staging/rtl8712/rtl8712_recv.c
>> +++ b/drivers/staging/rtl8712/rtl8712_recv.c
>> @@ -496,8 +496,7 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
>>   			plist = plist->next;
>>   		else if (SN_EQUAL(pnextattrib->seq_num, pattrib->seq_num))
>>   			return false;
>> -		else
>> -			break;
>> +		break;
>
>
> It's not the same logic.
> It would be if the code was:
>
> 	while (end_of_queue_search(phead, plist) == false) {
> 		pnextrframe = LIST_CONTAINOR(plist, union recv_frame, u);
> 		pnextattrib = &pnextrframe->u.hdr.attrib;
> 		if (SN_LESS(pnextattrib->seq_num, pattrib->seq_num)) {
> 			plist = plist->next;
> 			continue;
> 		} else if (SN_EQUAL(pnextattrib->seq_num, pattrib->seq_num)) {
> 			return false;
> 		}
> 		break;
> 	}
>
> But that's not necessary.

I have almost been tripped by this warning when the code said

	if (...) {
		.......
	} else if (...) {
		.......
		return;
	} else {
		.......
	}

Perhaps checkpatch should ignore setting this warning when there is an "else if" 
in the flow.

Larry

