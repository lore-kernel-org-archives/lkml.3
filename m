Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaFAPlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 11:41:15 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38195 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaFAPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 11:41:13 -0400
MIME-Version: 1.0
In-Reply-To: <AB19A214-D495-44EE-87E0-45332F156767@holtmann.org>
References: <1401631076-20818-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<AB19A214-D495-44EE-87E0-45332F156767@holtmann.org>
Date: Sun, 1 Jun 2014 17:41:12 +0200
Message-ID: <CAFo99gZVJ3D-f_j8C4zYBod4yaLveq8X5__URyTuOAKcffN-Cg@mail.gmail.com>
Subject: Re: [PATCH] net: bluetooth: hci_core.c: Cleaning up uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel!


Sorry sorry!! This is obviously not necessary!

This is code that was left when I tried to split up my original big patch.

This was part of code trying to solve a possible divided by 0.


    int q = 0;

...

    if (num)
        q = cnt / num;
    *quote = q ? q : 1;


But I'm not sure if it can happen in reality...
Guessing it will be caught by in that case by:

    if (!chan)
        return NULL;



I had actually not planned to submit this divided by 0 patch at all :-/


Best regards
Rickard Strandqvist


2014-06-01 16:24 GMT+02:00 Marcel Holtmann <marcel@holtmann.org>:
> Hi Rickard,
>
>> There is a risk that the variable will be used without being initialized.
>>
>> This was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>> net/bluetooth/hci_core.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>> index 1c6ffaa..1d93d2f 100644
>> --- a/net/bluetooth/hci_core.c
>> +++ b/net/bluetooth/hci_core.c
>> @@ -4603,7 +4603,7 @@ static struct hci_chan *hci_chan_sent(struct hci_dev *hdev, __u8 type,
>>       struct hci_chan *chan = NULL;
>>       unsigned int num = 0, min = ~0, cur_prio = 0;
>>       struct hci_conn *conn;
>> -     int cnt, q, conn_num = 0;
>> +     int cnt, q = 0, conn_num = 0;
>
> I have no idea on how the variable will be used without being initialized. Have you actually looked through that function. The only thing we do with q is assign it and then use it. That is it.
>
> Regards
>
> Marcel
>
