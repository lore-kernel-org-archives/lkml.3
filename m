Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaBLQVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:21:44 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:45072 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaBLQVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:21:40 -0500
Message-ID: <1392221703.5612.164.camel@misato.fc.hp.com>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at
 ffffffffff340003
From: Toshi Kani <toshi.kani@hp.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Madper Xie <cxie@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Josh Triplett <josh@joshtriplett.org>
Date: Wed, 12 Feb 2014 09:15:03 -0700
In-Reply-To: <20140211141846.GA1725@console-pimps.org>
References: <8738jr5t3e.fsf@redhat.com>
	 <20140210175246.GB2887@console-pimps.org> <87mwhy8iaj.fsf@redhat.com>
	 <20140211131640.GD2887@console-pimps.org> <87lhxh69u0.fsf@redhat.com>
	 <20140211141846.GA1725@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 14:18 +0000, Matt Fleming wrote:
> (Entering the realm of ACPI, pulling in more folks)
> 
> On Tue, 11 Feb, at 09:47:57PM, Madper Xie wrote:
> > Thanks for your reply. I attached the all the dmesg outputs for you.
> > [    0.000000] ACPI: BGRT 00000000d9bb5100 00003C (v00 HPQOEM SLIC-BPC 01072009 AMI  00010013)
>  
> Your BGRT table has an extra 4 bytes for some reason, (0x3C should be
> 0x38) and doesn't match the defintion in include/acpi/actbl3.h,
> 
> 
> struct acpi_table_bgrt {
> 	struct acpi_table_header header;	/* Common ACPI table header */
> 	u16 version;
> 	u8 status;
> 	u8 image_type;
> 	u64 image_address;
> 	u32 image_offset_x;
> 	u32 image_offset_y;
> };
> 
> 
> which explains why when we dereference ->image_address we don't get a
> sensible value.
> 
> Guys, what do you make of this? Firmware bug? Full thread here,
> 
>   http://article.gmane.org/gmane.linux.kernel.efi/3499
> 

Hi Matt,

Yes, I agree that the table size should be 0x38.  However, ACPI spec
states that bit0 of status indicates if the boot image graphic is valid.
This bit is set to 0 (invalid) on the system.  Can you check this bit
and return when invalid? 

Thanks,
-Toshi

