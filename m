Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3KAUIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:08:35 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753313Ab3KAUId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:08:33 -0400
Message-ID: <52740A3A.70202@nod.at>
Date: Fri, 01 Nov 2013 21:08:26 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: Tony Luck <tony.luck@gmail.com>, Madper Xie <cxie@redhat.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        =?GB2312?B?0Luzyb+l?= <bbboson@gmail.com>
Subject: Re: [PATCH] Make efi-pstore return a unique id
References: <87ppqk6qvx.fsf@redhat.com> <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com> <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.11.2013 20:22, schrieb Seiji Aguchi:
>>>> +{
>>>> +       char id_str[64];
>>>> +       u64 id = 0;
>>>> +
>>>> +       sprintf(id_str, "%lu%u%d", timestamp, part, count);
>>>> +       if (kstrtoull(id_str, 10, &id))
>>>> +               pr_warn("efi-pstore: failed to generate id\n");
>>>> +       return id;
>>>> +}
>>>
>>> This is just odd. You make a string from three ints and then a parse
>>> it to a int again.
>>
>> Agreed.  I liked your ((timestamp * 100 + part) * 100 + count function much
>> more than this.
> 
> I was worried that the part and count could be more than 100.
> If it happens, the id may not be unique...
> 
> But, currently, size of nvram storage is limited, so it is a corner case.
> I respect your opinion.

What about feeding the bytes of all three integers into a non-cryptographic hash function?
Using this way you get a cheap unique id.

Thanks,
//richard
