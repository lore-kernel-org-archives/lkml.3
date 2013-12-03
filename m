Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3LCBg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:36:27 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:2880 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab3LCBgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:36:25 -0500
Message-ID: <1386034289.1791.210.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
From: Toshi Kani <toshi.kani@hp.com>
To: Dave Young <dyoung@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org
Date: Mon, 02 Dec 2013 18:31:29 -0700
In-Reply-To: <1386023600.1791.201.camel@misato.fc.hp.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
	 <1385445477-9665-8-git-send-email-dyoung@redhat.com>
	 <20131127140732.GD32267@pd.tnic>
	 <20131129091415.GH4186@dhcp-16-126.nay.redhat.com>
	 <1386023600.1791.201.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 15:33 -0700, Toshi Kani wrote:
> On Fri, 2013-11-29 at 17:14 +0800, Dave Young wrote:
> > On 11/27/13 at 03:07pm, Borislav Petkov wrote:
> > > On Tue, Nov 26, 2013 at 01:57:52PM +0800, Dave Young wrote:
> > > > Add a new setup_data type SETUP_EFI for kexec use.
> > > > Passing the saved fw_vendor, runtime, config tables and
> > > > efi runtime mappings.
> > > > 
> > > > When entering virtual mode, directly mapping the efi
> > > > runtime ragions which we passed in previously. And skip
> > > > the step to call SetVirtualAddressMap.
> > > > 
> > > > Specially for HP z420 workstation it need another variable
> > > > saving,
> > > 
> > > Why the special handling? Does that mean, this is going to be the case
> > > for other HP UEFI implementations too?
> > 
> > I have only one HP machine for testing, Maybe Toshi can help to verify
> > on other machines. Just comment out the function efi_reuse_config to see
> > if kexec kernel panic.
> 
> My system (HP prototype server) did not need the special handling in
> efi_reuse_config().  I will check with firmware team to get more
> information on this.

I have one question.  I think this special handling assumes that
efi.smbios contains a virtual address on HP z420.  So, how does the 1st
kernel set a virtual address to efi.smbios in the first place?

Thanks,
-Toshi

