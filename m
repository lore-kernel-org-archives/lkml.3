Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3LGJCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 04:02:15 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:36545 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3LGJCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 04:02:11 -0500
Date: Sat, 7 Dec 2013 04:01:02 -0500 (EST)
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: mjg59@srcf.ucam.org, linux-efi@vger.kernel.org,
        toshi kani <toshi.kani@hp.com>, matt@console-pimps.org, greg@kroah.com,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        horms@verge.net.au, ebiederm@xmission.com, hpa@zytor.com,
        vgoyal@redhat.com
Message-ID: <2141297830.13051543.1386406862068.JavaMail.root@redhat.com>
In-Reply-To: <20131202094020.GA7380@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com> <1385445477-9665-7-git-send-email-dyoung@redhat.com> <20131127114402.GB32267@pd.tnic> <20131129094034.GI4186@dhcp-16-126.nay.redhat.com> <20131129115029.GB4266@pd.tnic> <20131202025942.GF3999@dhcp-16-126.nay.redhat.com> <20131202094020.GA7380@pd.tnic>
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to
 sysfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF12 (Linux)/8.0.3_GA_5664)
Thread-Topic: export efi runtime memory mapping to sysfs
Thread-Index: MaP0Dy7ViMa4RTVJDoUDKObn9Z4RBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Update my status:

I have finished most of thecode related changes including the krealloc
fixes (both for original code and my new code). And I'm slowly
moving the kexec related stuff to efi_kexec.c, this involves
some other cleanups, such as:
efi_systab_init:
 -> move 64bit code to efi_64.c, move 32bit code to efi_32.c

efi_setup global variable is changing to physical address, ioremapping
it when necessary instead of directly using the virt addr because
previously the virt addr will be freed until entering virtual mode,
it's possible a leak in case something is wrong in the middle also it
occupies the ioremap slot a little bit long.

There's also other problems, so I still need a few days probably
a week to carefully restructure the code.

Thanks
Dave

Sending from web interface so sorry for the email format.
----- Original Message -----
From: "Borislav Petkov" <bp@alien8.de>
To: "Dave Young" <dyoung@redhat.com>
Cc: mjg59@srcf.ucam.org, linux-efi@vger.kernel.org, "toshi kani" <toshi.kani@hp.com>, matt@console-pimps.org, greg@kroah.com, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, "James Bottomley" <James.Bottomley@HansenPartnership.com>, horms@verge.net.au, ebiederm@xmission.com, hpa@zytor.com, vgoyal@redhat.com
Sent: Monday, December 2, 2013 5:40:20 PM
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs

On Mon, Dec 02, 2013 at 10:59:42AM +0800, Dave Young wrote:
> They are only called if there's setup_data SETUP_EFI passed in. Yes, I
> think only kexec need that part of code. But I hesitated to mess the
> code with a lot of #if. Will think about it.

Well, the accepted strategy with the efi code is to have function calls
in efi.c and then have different versions of those functions defined for
32 and 64-bit, i.e. efi_32.c and efi_64.c.

I can imagine adding an efi_kexec.c could make the whole deal very
clearly arranged without ifdeffery.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

_______________________________________________
kexec mailing list
kexec@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/kexec
