Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3LYBwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 20:52:55 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:52523 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3LYBwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 20:52:53 -0500
Message-ID: <52BA3A72.6080700@gmail.com>
Date: Tue, 24 Dec 2013 19:52:50 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Vasiliy Tolstov <v.tolstov@selfip.ru>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: tg3 and sd card reader at acer aspire
References: <CACaajQv1OWxxcGORBq=LN-4JQzATf4YmWBQymoeyovfY-rUpmw@mail.gmail.com> <CAErSpo4uZ1N7uKyKMGHERtq-gvcpQ7oHTE7U9fGiAzfziMJ+Ew@mail.gmail.com>
In-Reply-To: <CAErSpo4uZ1N7uKyKMGHERtq-gvcpQ7oHTE7U9fGiAzfziMJ+Ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2013 11:52 AM, Bjorn Helgaas wrote:
> [+cc linux-pci because I think this is related to PCI ASPM]
>
> I'm afraid nobody wants to touch ASPM because it's such a mess, but I
> hope somebody will step up and investigate this.

So apparently this machine got broken when we changed the behavior for 
the ACPI ASPM-not-supported bit from forcing ASPM off for everything to 
leaving ASPM in whatever state the BIOS left it in. And apparently for 
some reason the device (devices?) doesn't work with ASPM enabled in 
Linux but does in Windows. It's possible that some other workaround is 
being applied by the Windows driver that allows it to work there.

I'm not too sure what the next step to debug that would be, unless maybe 
someone has a contact at Broadcom. We could conceivably add a quirk to 
force ASPM off for this device regardless of what the BIOS says, though.

>
> On Tue, Dec 24, 2013 at 1:27 AM, Vasiliy Tolstov <v.tolstov@selfip.ru> wrote:
>> Hi all and sorry for may be spamming mailing list.
>>
>> I have acer aspire v5-17 with broadcom card reader and ethernet card.
>> I'm affecting on this ubuntu bugs. But bug is present in vanilla linux
>> current git and stable lts.
>>
>> Can somebody helps me and say - where i can post message and discuss
>> this problem. As i see ubuntu team can't solve this problem (bug
>> present is about 1 year and nothing changed).
>> One ubuntu user wia bisecting find broken commit -
>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=6cac12dfab9c57a4f76821412224b226a9b08dff
>>
>> Relevant ubuntu bugs:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1178131
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1067222
>>
>>
>> Thanks!
>> --
>> Vasiliy Tolstov,
>> e-mail: v.tolstov@selfip.ru
>> jabber: vase@selfip.ru
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

