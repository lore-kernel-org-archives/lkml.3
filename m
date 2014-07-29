Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaG2WdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:33:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaG2WdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:33:20 -0400
Message-ID: <53D82118.6090202@redhat.com>
Date: Tue, 29 Jul 2014 18:32:56 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic>
In-Reply-To: <20140729222932.GA17481@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/29/2014 06:29 PM, Borislav Petkov wrote:
> On Tue, Jul 29, 2014 at 01:09:21PM -0400, Prarit Bhargava wrote:
>> The current debug print in EFI does
>>
>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (0MB)
>>
>> and rounds off the size to 0MB and isn't very useful.  We should print this in
>> Kib.  After applying this patch we get better info with
>>
>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (280kiB)
> 
> Turning this into kiB unconditionally won't always work ok:
> 
> First of all, there might be something which parses that output so I'd
> make sure I'm not breaking that. Maybe fwts... Matt will know.
> 
> Then, I have an UEFI region which is > 13G:
> 
> [    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x0000000450000000) (13568MB)
> 
> 
> With your patch it is even worse:
> 
> [    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x0000000450000000) (13893632kiB)
> 
> 
> I'd guess you'll have to go all out and do this properly. :-)
> 
> Something like showing the highest unit which is still > 1. In the above
> case, this should be (13GB) or maybe even introduce fractions.
> 
> Depends on how involved this output should be.

Yeah, I thought about doing something like that but figured if I'm at this level
I can do some math ;), and it was best to keep the code simple with a KiB.

Matt -- will anything be broken here if we change the output?

P.

> 
