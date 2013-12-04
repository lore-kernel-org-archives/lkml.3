Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3LDQsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:48:45 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:20782 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab3LDQsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:48:43 -0500
Message-ID: <1386175428.1791.225.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
From: Toshi Kani <toshi.kani@hp.com>
To: Dave Young <dyoung@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org
Date: Wed, 04 Dec 2013 09:43:48 -0700
In-Reply-To: <20131204024610.GA3764@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
	 <1385445477-9665-8-git-send-email-dyoung@redhat.com>
	 <20131127140732.GD32267@pd.tnic>
	 <20131129091415.GH4186@dhcp-16-126.nay.redhat.com>
	 <1386023600.1791.201.camel@misato.fc.hp.com>
	 <1386034289.1791.210.camel@misato.fc.hp.com>
	 <20131203015613.GB3980@dhcp-16-126.nay.redhat.com>
	 <1386085140.1791.218.camel@misato.fc.hp.com>
	 <20131204024610.GA3764@dhcp-16-126.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 10:46 +0800, Dave Young wrote:
> Hi, Toshi
> 
> > Oh, I think I now understand what the issue was.  The z420 firmware
> > updates the SMBIOS table address in the EFI system table to a virtual
> > address after calling EFI SetVirtualAddressMap.  So, you are passing the
> > original physical address of the SMBIOS table from the 1st kernel to the
> > 2nd kernel to put it back to physical.  Is that right? 
> 
> Right.

Hi Dave,

The z420 firmware is based on some UEFI core that may be used by other
vendors as well.  Since this handling is totally harmless (just
redundant), I'd suggest not to have a platform check on this handling.

Thanks,
-Toshi

