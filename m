Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbaGNRIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:08:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43957 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306AbaGNRI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:08:27 -0400
Message-ID: <53C40D83.3090501@zytor.com>
Date: Mon, 14 Jul 2014 10:04:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Is espfix64's double-fault thing OK on Xen?
References: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com>
In-Reply-To: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 04:17 PM, Andy Lutomirski wrote:
> This part in __do_double_fault looks fishy:
> 
>     cmpl $__KERNEL_CS,CS(%rdi)
>     jne do_double_fault
> 
> Shouldn't that be:
> 
>     test $3,CS(%rdi)
>     jnz do_double_fault
> 

No, it should be fine.  The *only* case where we need to do the espfix
magic is when we are on __KERNEL_CS.

	-hpa


