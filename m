Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaBKOSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:18:52 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:44345 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbaBKOSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:18:51 -0500
Date: Tue, 11 Feb 2014 14:18:46 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Madper Xie <cxie@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at
 ffffffffff340003
Message-ID: <20140211141846.GA1725@console-pimps.org>
References: <8738jr5t3e.fsf@redhat.com>
 <20140210175246.GB2887@console-pimps.org>
 <87mwhy8iaj.fsf@redhat.com>
 <20140211131640.GD2887@console-pimps.org>
 <87lhxh69u0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhxh69u0.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Entering the realm of ACPI, pulling in more folks)

On Tue, 11 Feb, at 09:47:57PM, Madper Xie wrote:
> Thanks for your reply. I attached the all the dmesg outputs for you.
> [    0.000000] ACPI: BGRT 00000000d9bb5100 00003C (v00 HPQOEM SLIC-BPC 01072009 AMI  00010013)
 
Your BGRT table has an extra 4 bytes for some reason, (0x3C should be
0x38) and doesn't match the defintion in include/acpi/actbl3.h,


struct acpi_table_bgrt {
	struct acpi_table_header header;	/* Common ACPI table header */
	u16 version;
	u8 status;
	u8 image_type;
	u64 image_address;
	u32 image_offset_x;
	u32 image_offset_y;
};


which explains why when we dereference ->image_address we don't get a
sensible value.

Guys, what do you make of this? Firmware bug? Full thread here,

  http://article.gmane.org/gmane.linux.kernel.efi/3499

-- 
Matt Fleming, Intel Open Source Technology Center
