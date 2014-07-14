Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbaGNWX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:23:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47028 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaGNWX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:23:28 -0400
Message-ID: <53C45857.6050605@zytor.com>
Date: Mon, 14 Jul 2014 15:23:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Is espfix64's double-fault thing OK on Xen?
References: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com> <53C40D83.3090501@zytor.com> <CALCETrU44CM5=hSOMQGB6eEM2g-h6y5_+-SwoMwu+-qp-Pxd7g@mail.gmail.com> <CALCETrVz7a7RVLhYTrGvHkJR2dGHJbRuATOaWaXgkrSABR7YFA@mail.gmail.com> <CALCETrU9dmM+bsQYwULjiqw5+erKsu5yUmHJDGYUW1wpcdp-5Q@mail.gmail.com> <CALCETrWG-dQL8ipJ8cO3wfbYKA=mAv3CS4-1JFwmBXF3pUbAwg@mail.gmail.com>
In-Reply-To: <CALCETrWG-dQL8ipJ8cO3wfbYKA=mAv3CS4-1JFwmBXF3pUbAwg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 02:35 PM, Andy Lutomirski wrote:
> Presumably the problem is here:
> 
> ENTRY(xen_iret)
>     pushq $0
> 1:    jmp hypercall_iret
> ENDPATCH(xen_iret)
> 
> This seems rather unlikely to work on the espfix stack.
> 
> Maybe espfix64 should be disabled when running on Xen and Xen should
> implement its own espfix64 in the hypervisor.

Perhaps the first question is: is espfix even necessary on Xen?  How
does the Xen PV IRET handle returning to a 16-bit stack segment?

	-hpa


