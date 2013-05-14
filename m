Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3ENEjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 00:39:46 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:39607 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3ENEjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 00:39:43 -0400
Subject: Re: [PATCH] efivarfs: Never return ENOENT from firmware again
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>, Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Andy Whitcroft <apw@canonical.com>
In-Reply-To: <51913D4B.2000606@intel.com>
References: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>
	 <51913D4B.2000606@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 May 2013 12:36:37 +0800
Message-ID: <1368506197.21417.172.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt, 

於 一，2013-05-13 於 20:21 +0100，Matt Fleming 提到：
> On 05/10/2013 11:29 AM, Lingzhu Xiang wrote:
> > Previously in 1fa7e69 efi_status_to_err() translated firmware status
> > EFI_NOT_FOUND to -EIO instead of -ENOENT for efivarfs operations to
> > avoid confusion. After refactoring in e14ab23, it is also used in other
> > places where the translation may be unnecessary.
> > 
> > So move the translation to efivarfs specific code. Also return EOF
> > for reading zero-length files, which is what users would expect.
> > 
> > Cc: Josh Boyer <jwboyer@redhat.com>
> > Cc: Jeremy Kerr <jk@ozlabs.org>
> > Cc: Lee, Chun-Yi <jlee@suse.com>
> > Cc: Andy Whitcroft <apw@canonical.com>
> > Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
> > ---
> > This is to be applied against mainline or Matt Fleming's chainsaw branch.
> 
> Applied, thanks.
> 
> FYI, I rebased my 'urgent' branch on v3.10-rc1, so your patch now
> applies there too.
> 
> 

I found the "[PATCH] x86, efi: initial the local variable of DataSize to
zero" lost in urgent branch, and it also didn't in Linus's v3.10-rc1.

Did this patch move to other branch?


Thanks a lot!
Joey Lee




