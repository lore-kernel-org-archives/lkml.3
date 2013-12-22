Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3LVVcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 16:32:45 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27616 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab3LVVcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 16:32:43 -0500
Message-ID: <1387747621.1848.2.camel@misato.fc.hp.com>
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
From: Toshi Kani <toshi.kani@hp.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "bp@alien8.de" <bp@alien8.de>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>
Date: Sun, 22 Dec 2013 14:27:01 -0700
In-Reply-To: <20131221173515.GE29501@console-pimps.org>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
	 <20131221173515.GE29501@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-21 at 17:35 +0000, Matt Fleming wrote:
> On Fri, 20 Dec, at 06:02:10PM, Dave Young wrote:
> > Here is the V7 patchset for supporting kexec kernel efi runtime.
> > Per pervious discussion I pass the 1st kernel efi runtime mapping
> > via setup_data to 2nd kernel. Besides of the runtime mapping
> > info I also pass the fw_vendor, runtime, config table, smbios
> > physical address in setup_data. EFI spec mentioned fw_vendor,
> > runtime, config table addresses will be converted to virt address
> > after entering virtual mode, but we will use it as physical address
> > in efi_init. For smbios EFI spec did not mention about the address
> > updating, but during my test on a HP workstation, the bios will
> > convert it to Virt addr, thus pass it in setup_data as well.
> 
> OK Dave, I've pulled patches 3-12 into the 'kexec' branch at,
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> 
> I plan on sending this branch to the tip folks this week for further
> testing.
> 
> Please have a look and make sure I haven't messed anything up when
> dropping the first two patches (though they were very small and trival).
> 
> Toshi, if you could grab that branch and give it a test, that'd be
> excellent.

The kexec branch is missing the following change, which is required for
fast reboot with multi-cpus.

   commit 279f1df915c3a6ed3075d98a849705bf53851f99
   Author: Vivek Goyal <vgoyal@redhat.com>
   Date:   Tue Nov 26 10:25:28 2013 +0800

       kexec: migrate to reboot cpu

With this change added, I confirmed that the branch kernel works fine.

Thanks,
-Toshi

