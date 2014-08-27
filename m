Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbaH0Kap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:30:45 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56488 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaH0Kan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:30:43 -0400
Date: Wed, 27 Aug 2014 11:30:38 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Harald Hoyer <harald@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH V2] efi_high_alloc: use EFI_ALLOCATE_MAX_ADDRESS
Message-ID: <20140827103038.GB28116@console-pimps.org>
References: <1408715303-2215-1-git-send-email-harald@redhat.com>
 <1408967732-2381-1-git-send-email-harald@redhat.com>
 <20140825130724.GT29733@console-pimps.org>
 <53FB4952.1090104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FB4952.1090104@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug, at 04:33:54PM, Harald Hoyer wrote:
> 
> So is that ok, if other callers of efi_high_alloc() get an address >
> 4GB?

Yeah, the issue at hand is that some x86 EFI firmware cannot perform a
file read into a buffer above 4G. The actual allocation works fine.

If other callers want a high address buffer, they're not going to hit
that issue. We've no reason to believe that this bug affects arm64 at
all, for instance.

Working around this problem in efi_high_alloc() gives the impression
that there's something wrong with AllocatePages(), which isn't the case.

> Will the buggy EFI implementation work with the usage of the other
> caller's allocated memory? Or will they run into the same issues as
> the initramfs loader?

Based on the information we've gathered so far, there's no reason to
believe other callers will hit the same issue as the file reading code.

-- 
Matt Fleming, Intel Open Source Technology Center
