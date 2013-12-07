Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab3LGVso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 16:48:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43612 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098Ab3LGVsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 16:48:41 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131207133048.GA4183@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com> <1385445477-9665-7-git-send-email-dyoung@redhat.com> <20131127114402.GB32267@pd.tnic> <20131129094034.GI4186@dhcp-16-126.nay.redhat.com> <20131129115029.GB4266@pd.tnic> <20131202025942.GF3999@dhcp-16-126.nay.redhat.com> <20131202094020.GA7380@pd.tnic> <2141297830.13051543.1386406862068.JavaMail.root@redhat.com> <20131207133048.GA4183@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 07 Dec 2013 13:46:33 -0800
To: Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>
CC: mjg59@srcf.ucam.org, linux-efi@vger.kernel.org,
        toshi kani <toshi.kani@hp.com>, matt@console-pimps.org, greg@kroah.com,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        horms@verge.net.au, ebiederm@xmission.com, vgoyal@redhat.com
Message-ID: <e42e2c5d-98cc-4375-8ff9-1448989fdb73@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is very good advice indeed.

Borislav Petkov <bp@alien8.de> wrote:
>On Sat, Dec 07, 2013 at 04:01:02AM -0500, Dave Young wrote:
>> Hi, all
>> 
>> Update my status:
>> 
>> I have finished most of thecode related changes including the
>krealloc
>> fixes (both for original code and my new code). And I'm slowly
>> moving the kexec related stuff to efi_kexec.c, this involves
>> some other cleanups, such as:
>> efi_systab_init:
>>  -> move 64bit code to efi_64.c, move 32bit code to efi_32.c
>> 
>> efi_setup global variable is changing to physical address,
>ioremapping
>> it when necessary instead of directly using the virt addr because
>> previously the virt addr will be freed until entering virtual mode,
>> it's possible a leak in case something is wrong in the middle also it
>> occupies the ioremap slot a little bit long.
>> 
>> There's also other problems, so I still need a few days probably
>> a week to carefully restructure the code.
>
>Those are all lofty goals but beware that trying to solve it all at
>once can be very painful and can cause unnecessary work for both coders
>and reviewers. Especially if the patchset grows out of proportion which
>makes it much harder to review and deal with.
>
>So, from my experience and if I were you, I'd try to address the most
>important issue I'm trying to fix, have 10ish nice clean patches and
>put
>the rest on the TODO list. This is much easier to deal with for
>everyone
>involved than trying to solve it all at once.
>
>Besides, if you solve it all at once, what are you going to work on
>afterwards? :-)
>
>HTH.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
