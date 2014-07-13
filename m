Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaGMQMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 12:12:35 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62799 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbaGMQM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 12:12:26 -0400
Message-ID: <53C2AFE7.5080505@gmail.com>
Date: Sun, 13 Jul 2014 19:12:23 +0300
From: Avi Kivity <avi.kivity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Northup <digitaleric@google.com>
CC: KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86 emulator: emulate MOVNTDQ
References: <20140711175345.19079.28143.stgit@gimli.home>	 <CAG7+5M3Er0bd2pnuGjzp8z8MMBJG9bKTpsCQ_SrZASnjcwLW5A@mail.gmail.com> <1405109152.4098.99.camel@ul30vt.home> <53C04BDB.1080707@redhat.com>
In-Reply-To: <53C04BDB.1080707@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/11/2014 11:40 PM, Paolo Bonzini wrote:
> Il 11/07/2014 22:05, Alex Williamson ha scritto:
>> Which will return 'true' for this whether I specify Aligned or not.  If
>> the standard convention is to make it explicit, I'm happy to add the
>> extra flag, but I think we already #GP on unaligned as implemented here.
>> Thanks,
>
> We should still specify Aligned if the corresponding AVX instruction 
> requires an aligned operand.  ISTR that this is not the case for 
> MOVNTDQ, so your patch is correct.  I'll check the SDM more carefully 
> next Monday.
>

The explicitly aligned/unaligned instructions have an A or a U to 
indicate this (e.g. MOVDQU = explicitly unaligned, MOVDQA = explicitly 
aligned, MOVNTDQ = default).

