Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3HEO0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:26:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab3HEOZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:25:58 -0400
Message-ID: <51FFB660.4060400@redhat.com>
Date: Mon, 05 Aug 2013 16:27:44 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
References: <20130731205431.GG4724@pd.tnic> <1375307727.22084.103.camel@shinybook.infradead.org> <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com> <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com> <20130805140306.GD31845@pd.tnic>
In-Reply-To: <20130805140306.GD31845@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 16:03, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 03:39:31PM +0200, Laszlo Ersek wrote:
>> My question was: is my understanding correct that you only see this
>> problem with "-enable-kvm"? Because,
>>
>> On 08/01/13 18:49, Borislav Petkov wrote:
>>> so I'm seeing this funny thing where an EFI region changes when we
>>> enter efi_enter_virtual_mode when booting with edk2 on kvm. Here's
>>> the diff:
>>
>> You said "on kvm", and provided a diff. I think (hope) I understand the
>> environment you've denoted with "after", but what's your "before"? The
>> absence of "-enable-kvm", or something else?
> 
> Ah, I see.
> 
> So 'before' is the initial dump of the EFI regions, very early during
> boot:

<snip>

> and with 'after' I've denoted the dump of the EFI regions a second time,
> a bit later, when we enter efi_enter_virtual_mode():

<snip>

> 
> during the *same* boot.
> 
> So, it is one boot but two dumps of the EFI regions. And yes, I'm
> booting with the 'kvm' executable which has '-enable-kvm'

Okay. Thanks for clarifying it.

> 
>> What's the purpose of that series? Can you please provide a link (if
>> you posted versions of it already)?
> 
> Not yet posted but working on it.
> 
> The idea is to map the runtime regions at stable addresses so that when
> we kexec a kernel, it can use runtime services too. And we have to do
> that because of the braindead design of SetVirtualAddressMap() being
> callable only once per boot.

I wouldn't call the design of SetVirtualAddressMap() braindead.

I'd rather call kexec unique and somewhat unexpected :)

> 
>>> So what basically happens is the end boundary of the region becomes the
>>> start, practically turning it into a 0-size one.
>>
>> ... and you guys suspect that some firmware code is responsible, code
>> that runs between the initial memory map dump, and efi_enter_virtual_mode():
>>
>> https://lkml.org/lkml/2013/7/31/550
> 
> I wouldn't wonder if we f*cked it up again like the last time. I'll give
> it a long hard look.

Ah sorry, by "and you guys suspect" I didn't mean to imply anything
between the lines, I was simply trying to ascertain your working idea :)

Laszlo
