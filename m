Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaJMPny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:43:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbaJMPnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:43:53 -0400
Message-ID: <543BF304.9090708@zytor.com>
Date: Mon, 13 Oct 2014 08:43:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Baoquan He <bhe@redhat.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, ak@linux.intel.com, ebiederm@xmission.com,
        kexec@lists.infradead.org, whissi@whissi.de,
        kumagai-atsushi@mxc.nes.nec.co.jp, stable@vger.kernel.org
Subject: Re: [resend Patch v3 1/2] kaslr: check if kernel location is changed
References: <1412060896-1902-1-git-send-email-bhe@redhat.com> <542B1EC1.8090502@zytor.com> <20141001135237.GA13689@redhat.com> <543553C7.9010906@zytor.com> <20141008192728.GA26517@redhat.com> <20141011031452.GB11560@dhcp-16-116.nay.redhat.com> <543907B5.7060001@zytor.com> <20141013125257.GB6466@redhat.com> <20141013151955.GA9777@redhat.com>
In-Reply-To: <20141013151955.GA9777@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 08:19 AM, Vivek Goyal wrote:
>>>
>>> This really shouldn't have happened this way on x86-64.  It has to happen
>>> this way on i386, but I worry that this may be a serious misdesign in kaslr
>>> on x86-64.  I'm also wondering if there is any other fallout of this?
>>
>> I agree. On x86_64, we should stick to previous design and this new
>> logic of performing relocations does not sound very clean and makes
>> things very confusing.
>>
>> I am wondering that why couldn't we simply adjust page tables in case of
>> kaslr on x86_64, instead of performing relocations.
> 
> Well, IIUC, if virtual addresses are shifted w.r.t what virtual address
> kernel was compiled for, then relocation will have to be done.
> 
> So question will be if physical address shift is enough for kaslr or
> virtual address shift is necessary.
> 

I would assume that without a virtual address shift kaslr is pretty darn
pointless.  Without the physical address shift the 1:1 map can be used,
and again, kaslr becomes pointless.  However, there is absolutely no
reason why they should be coupled.  They can, in fact, be independently
randomized.

	-hpa


