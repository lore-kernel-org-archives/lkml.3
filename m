Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3KBBPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 21:15:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab3KBBPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 21:15:53 -0400
References: <87ppqk6qvx.fsf@redhat.com> <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com> <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com> <52740A3A.70202@nod.at>
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Tony Luck <tony.luck@gmail.com>,
        Madper Xie <cxie@redhat.com>,
        "matt.fleming\@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        =?utf-8?B?6LCi5oiQ6aqP?= <bbboson@gmail.com>
Subject: Re: [PATCH] Make efi-pstore return a unique id
In-reply-to: <52740A3A.70202@nod.at>
Date: Sat, 02 Nov 2013 09:15:35 +0800
Message-ID: <87mwln7geg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard@nod.at writes:

> Am 01.11.2013 20:22, schrieb Seiji Aguchi:
>>>>> +{
>>>>> +       char id_str[64];
>>>>> +       u64 id = 0;
>>>>> +
>>>>> +       sprintf(id_str, "%lu%u%d", timestamp, part, count);
>>>>> +       if (kstrtoull(id_str, 10, &id))
>>>>> +               pr_warn("efi-pstore: failed to generate id\n");
>>>>> +       return id;
>>>>> +}
>>>>
>>>> This is just odd. You make a string from three ints and then a parse
>>>> it to a int again.
>>>
>>> Agreed.  I liked your ((timestamp * 100 + part) * 100 + count function much
>>> more than this.
>> 
>> I was worried that the part and count could be more than 100.
>> If it happens, the id may not be unique...
>> 
>> But, currently, size of nvram storage is limited, so it is a corner case.
>> I respect your opinion.
>
Is it really safe? for now I have more than 100 entries:
[root@dhcp-13-41 rhel6]# ls -l /dev/pstore/ | wc -l
124
The maximum part of my records is 16. But I not sure if overflow will
happen in some special case, like a very long dmesg output. or a server
never reboot, and too many warnings make count++...
So is it necessary to check count < 100 or 100 =< count < 1000 ?
> What about feeding the bytes of all three integers into a non-cryptographic hash function?
> Using this way you get a cheap unique id.
>
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Best,
Madper Xie.
