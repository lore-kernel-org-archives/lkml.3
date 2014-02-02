Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaBBWp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 17:45:59 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:57692 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaBBWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 17:45:58 -0500
MIME-Version: 1.0
X-Originating-IP: [121.99.39.170]
In-Reply-To: <CA+5PVA4BGAN79T-k2_PBYgFeJYuJ5GB0z7+-2isAgpcbGjWN0Q@mail.gmail.com>
References: <CA+5PVA4BGAN79T-k2_PBYgFeJYuJ5GB0z7+-2isAgpcbGjWN0Q@mail.gmail.com>
Date: Mon, 3 Feb 2014 11:45:57 +1300
Message-ID: <CAD3Canf=nK+uS=sbxAP5-_ikFfxE3Ta-L5R2Y0tkLYAVT=J2KA@mail.gmail.com>
Subject: Re: [Xen-devel] Xen build error on ARM with 3.14 merge window kernels
From: Matthew Daley <mattd@bugfuzz.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xenproject.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 11:29 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> Hi All,
>
> With v3.13-11147-gb399c46 I'm seeing the following build errors for
> Xen on ARM.  I haven't been able to test Linus' recent tree yet, but I
> was wondering if anyone had seen this yet.

It's just recently been brought up. Check out message
<52EE1E26.2040308@linaro.org>:
http://thread.gmane.org/gmane.linux.kernel/1634907/focus=1638931

- Matthew

>
> josh
>
> drivers/xen/grant-table.c: In function '__gnttab_map_refs':
> drivers/xen/grant-table.c:989:3: error: implicit declaration of
> function 'FOREIGN_FRAME' [-Werror=implicit-function-declaration]
>    if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)))) {
>    ^
> drivers/xen/grant-table.c: In function '__gnttab_unmap_refs':
> drivers/xen/grant-table.c:1054:3: error: implicit declaration of
> function 'get_phys_to_machine' [-Werror=implicit-function-declaration]
>    mfn = get_phys_to_machine(pfn);
>    ^
> drivers/xen/grant-table.c:1055:43: error: 'FOREIGN_FRAME_BIT'
> undeclared (first use in this function)
>    if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
>                                            ^
> drivers/xen/grant-table.c:1055:43: note: each undeclared identifier is
> reported only once for each function it appears in
> drivers/xen/grant-table.c:1068:9: error: too many arguments to
> function 'm2p_remove_override'
>          mfn);
>          ^
> In file included from include/xen/page.h:4:0,
>                  from drivers/xen/grant-table.c:48:
> /home/jwboyer/rpmbuild/BUILD/kernel-3.13.fc20/linux-3.14.0-0.rc0.git20.1.fc20.armv7hl/arch/arm/include/asm/xen/page.h:106:19:
> note: declared here
>  static inline int m2p_remove_override(struct page *page, bool clear_pte)
>                    ^
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/xen/grant-table.o] Error 1
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
