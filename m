Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3HUXE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:04:57 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:58563 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3HUXEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:04:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130821190307.GB18673@moon>
References: <5214C524.1050900@citrix.com>
	<20130821141223.GS18673@moon>
	<5214F09002000078000ED5C3@nat28.tlf.novell.com>
	<20130821154238.GV18673@moon>
	<521500E102000078000ED65C@nat28.tlf.novell.com>
	<20130821161946.GW18673@moon>
	<5214F128.1000901@citrix.com>
	<20130821172547.GY18673@moon>
	<20130821181733.GC3814@moon>
	<4fec3e5b-695c-438b-ad6d-55ca50becc4c@email.android.com>
	<20130821190307.GB18673@moon>
Date: Wed, 21 Aug 2013 16:04:54 -0700
X-Google-Sender-Auth: Z5jiWxyQoDXnqQeKlyCG7K5Xqjk
Message-ID: <CA+55aFw_tWio_ABFUocNHU+_RKe-27U9_=4ATfp3-vSWVZkdug@mail.gmail.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>, Xen-devel@lists.xen.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Emelyanov <xemul@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 12:03 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
> I personally don't see bug here because
>
>  - this swapped page soft dirty bit is set for non-present entries only,
>    never for present ones, just at moment we form swap pte entry
>
>  - i don't find any code which would test for this bit directly without
>    is_swap_pte call

Ok, having gone through the places that use swp_*soft_dirty(), I have
to agree. Afaik, it's only ever used on a swap-entry that has (by
definition) the P bit clear. So with or without Xen, I don't see how
it can make any difference.

David/Konrad - did you actually see any issues, or was this just from
(mis)reading the code?

                Linus
