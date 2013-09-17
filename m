Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab3IQPqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:46:34 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50628 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828Ab3IQPqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:46:33 -0400
Date: Tue, 17 Sep 2013 16:46:30 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: access efi variables
Message-ID: <20130917154630.GG3409@console-pimps.org>
References: <52333139.6020203@broadcom.com>
 <5233939B.3020401@zytor.com>
 <5234965F.3050404@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5234965F.3050404@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Sep, at 07:01:19PM, Arend van Spriel wrote:
> On 09/14/13 00:37, H. Peter Anvin wrote:
> >On 09/13/2013 08:37 AM, Arend van Spriel wrote:
> >>I need to obtain a uefi variable so I went looking at the API in
> >>include/linux/efi.h. I found the following definition:
> >>
> >>But according to the specs the variable I need to obtain is 2k bytes.
> >>Should I expect trouble :-p
> >>
> >
> >efivarfs doesn't have those limitations.
> 
> Thanks, Peter
> 
> Looking into efivarfs it seems to use the functions that I looked at
> in efi.h so I guess I am misinterpreting the 1024 bytes limitation
> in the comment (either that or you are mistaken ;-) ). I need to
> access the variable from within a device driver so using efivarfs
> does not feel like the way to go here.

Look at how efivarfs_file_read() is implemented, e.g. using
efivar_entry_get(). In particular, note how it kmalloc()'s a buffer for
reading the variable data into, thereby avoiding any 1024-byte
limitation.

-- 
Matt Fleming, Intel Open Source Technology Center
