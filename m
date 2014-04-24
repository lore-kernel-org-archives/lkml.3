Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaDXXqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:46:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33724 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbaDXXqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:46:24 -0400
Message-ID: <5359A243.9010606@zytor.com>
Date: Thu, 24 Apr 2014 16:46:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Dave Young <dyoung@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kaslr should avoid setup_data region
References: <20140424023544.GA2180@darkstar.nay.redhat.com>	<CAGXu5j+TP2=iVYj=a6YGiGdOUqznb1MxdLLz5tjL8Hwwcq2K0Q@mail.gmail.com>	<20140424025016.GB2180@darkstar.nay.redhat.com> <CAGXu5jKaog6X+jw6Zh3iHSHS8KFUbLEHm75=HbVORJ-crpr7Fw@mail.gmail.com>
In-Reply-To: <CAGXu5jKaog6X+jw6Zh3iHSHS8KFUbLEHm75=HbVORJ-crpr7Fw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 03:50 PM, Kees Cook wrote:
> Ah, it sounds like boot_params.hdr.setup_data contains a series of
> e820-like entries chained together as a linked list? Which loaders
> currently populate that? Looks like EFI? Seems like
> arch/x86/boot/compressed/eboot.c works on setup_data at least.
> 
> I won't be in a position to test EFI booting for a while. If someone
> else took this, that would make it get fixed much faster.
> 
> Do you have examples where this is actually causing failures?
> 
> -Kees

Syslinux can populate it with arbitrary data; in particular Syslinux
uses it to pass FDT information if requested.

	-hpa


