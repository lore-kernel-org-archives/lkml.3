Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3HVGlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:41:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:34101 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab3HVGlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:41:45 -0400
Message-ID: <5215B2A2.6090705@parallels.com>
Date: Thu, 22 Aug 2013 10:41:38 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>, <Xen-devel@lists.xen.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <dhillf@gmail.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
References: <5214F09002000078000ED5C3@nat28.tlf.novell.com> <20130821154238.GV18673@moon> <521500E102000078000ED65C@nat28.tlf.novell.com> <20130821161946.GW18673@moon> <5214F128.1000901@citrix.com> <20130821172547.GY18673@moon> <20130821181733.GC3814@moon> <4fec3e5b-695c-438b-ad6d-55ca50becc4c@email.android.com> <20130821190307.GB18673@moon> <CA+55aFw_tWio_ABFUocNHU+_RKe-27U9_=4ATfp3-vSWVZkdug@mail.gmail.com> <20130822005115.GA1188@redhat.com>
In-Reply-To: <20130822005115.GA1188@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 04:51 AM, Dave Jones wrote:
> On Wed, Aug 21, 2013 at 04:04:54PM -0700, Linus Torvalds wrote:
>  > On Wed, Aug 21, 2013 at 12:03 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>  > >
>  > > I personally don't see bug here because
>  > >
>  > >  - this swapped page soft dirty bit is set for non-present entries only,
>  > >    never for present ones, just at moment we form swap pte entry
>  > >
>  > >  - i don't find any code which would test for this bit directly without
>  > >    is_swap_pte call
>  > 
>  > Ok, having gone through the places that use swp_*soft_dirty(), I have
>  > to agree. Afaik, it's only ever used on a swap-entry that has (by
>  > definition) the P bit clear. So with or without Xen, I don't see how
>  > it can make any difference.
>  > 
>  > David/Konrad - did you actually see any issues, or was this just from
>  > (mis)reading the code?
> 
> Could this explain what I'm seeing in another thread ?
> https://lkml.org/lkml/2013/8/7/27

Was it caught with CONFIG_MEM_SOFT_DIRTY on or off? In the latter case all new 
bits manipulations are no-op and couldn't cause this.

> 	Dave

Thanks,
Pavel
