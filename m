Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab3HMRqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:46:34 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:48614 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3HMRqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:46:32 -0400
Message-ID: <520A70FC.6080003@cogentembedded.com>
Date: Tue, 13 Aug 2013 21:46:36 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rupesh Gujare <rupesh.gujare@atmel.com>
CC: devel@linuxdriverproject.org, dan.carpenter@oracle.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 07/10] staging: ozwpan: Make oz_hcd_pd_departed() take
 a struct pointer.
References: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com> <1376414966-23525-3-git-send-email-rupesh.gujare@atmel.com> <520A6E5B.3020303@cogentembedded.com> <520A6F75.8010308@atmel.com>
In-Reply-To: <520A6F75.8010308@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 09:40 PM, Rupesh Gujare wrote:

>>> oz_hcd_pd_departed() takes struct oz_port pointer instead of
>>> void *, change function declaration to avoid ambiguity.

>>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>>> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
>>> ---
>>>   drivers/staging/ozwpan/ozhcd.c |    4 ++--
>>>   drivers/staging/ozwpan/ozhcd.h |    2 +-
>>>   2 files changed, 3 insertions(+), 3 deletions(-)

>>> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
>>> index 73d80f2..ed3ffeb 100644
>>> --- a/drivers/staging/ozwpan/ozhcd.c
>>> +++ b/drivers/staging/ozwpan/ozhcd.c
>>> @@ -720,9 +720,9 @@ out:
>>>    * polled. We release the reference we hold on the PD.
>>>    * Context: softirq
>>>    */
>>> -void oz_hcd_pd_departed(void *hport)
>>> +void oz_hcd_pd_departed(struct oz_port *hport)
>>>   {
>>> -    struct oz_port *port = (struct oz_port *)hport;
>>> +    struct oz_port *port = hport;

>>    Do you really need a copy? Isn't it better to rename the parameter and
>> remove this line altogether?

>> WBR, Sergei

> Yes, that is the idea,  for next patch series, as I don't want to mix two
> changes in single patch.

    Don't think it's worth another series.

WBR, Sergei

