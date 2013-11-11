Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3KKJsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:48:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab3KKJr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:47:59 -0500
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at> <527CB013.30200@jp.fujitsu.com> <527CB0F4.8080606@nod.at> <527CBC05.6080505@jp.fujitsu.com> <527CBD01.1000908@nod.at> <527CBDD3.2020609@jp.fujitsu.com> <20131108143421.GB22636@console-pimps.org> <52809AEB.9080100@jp.fujitsu.com>
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Matt Fleming <matt@console-pimps.org>, Richard Weinberger <richard@nod.at>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, matthew.garrett@nebula.com, jlee@suse.com
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter to efi_storage_paranoia
Message-ID: <87eh6ngthv.fsf@redhat.com>
In-reply-to: <52809AEB.9080100@jp.fujitsu.com>
Date: Mon, 11 Nov 2013 17:47:30 +0800
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy Yasuaki,
  I know some boxes with small NVRAM (less than 64kb?) will meet many
  issues if we always keep ~5kb free space.
  But if we really do not keep some free space as default, many box will
  become a brick. (In fact, I just fixed a bricked dell xps 8500 last
  week. 5kb is not enough for dell xps...)
  So maybe the better way is: we check the size of nvram and decide how
  many space we retain.
  
isimatu.yasuaki@jp.fujitsu.com writes:

> Hi Matt,
>
> I uses FUJITSU's x86 box.
> This does not become bricked even if I use all efi variable storage.
> Thus I want a way to not need to specify efi_no_storage_paranoia
> parameter.
>
> Thanks,
> Yasuaki Ishimatsu
>
>
> (2013/11/08 23:34), Matt Fleming wrote:
>> On Fri, 08 Nov, at 07:32:51PM, Yasuaki Ishimatsu wrote:
>>>> Everything started with an issue that killed Samsung laptops:
>>>> http://mjg59.dreamwidth.org/22855.html
>>>>
>>>> Later it was found that if you write too much into UEFI variables many
>>>> UEFI implementations will do bad things.
>>>
>>> Thanks for the information.
>>> I will read it.
>>
>> Out of curiosity, what hardware are you using?
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Best,
Madper Xie.
