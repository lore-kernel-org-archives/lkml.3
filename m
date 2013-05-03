Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835Ab3ECIuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:50:15 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50785 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755266Ab3ECIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:50:12 -0400
Date: Fri, 3 May 2013 09:50:04 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: matt.fleming@intel.com, mjg59@srcf.ucam.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, efi: initial the local variable of DataSize to zero
Message-ID: <20130503085004.GD2254@console-pimps.org>
References: <1367503621-13004-1-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367503621-13004-1-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 May, at 10:07:01PM, Lee, Chun-Yi wrote:
> That will be better initial the value of DataSize to zero for the input of
> GetVariable(), otherwise we will feed a random value. The debug log of input
> DataSize like this:
> 
> ...
> [  195.915612] EFI Variables Facility v0.08 2004-May-17
> [  195.915819] efi: size: 18446744071581821342
> [  195.915969] efi:  size': 18446744071581821342
> [  195.916324] efi: size: 18446612150714306560
> [  195.916632] efi:  size': 18446612150714306560
> [  195.917159] efi: size: 18446612150714306560
> [  195.917453] efi:  size': 18446612150714306560
> ...
> 
> The size' is value that was returned by BIOS.
> 
> After applied this patch:
> [   82.442042] EFI Variables Facility v0.08 2004-May-17
> [   82.442202] efi: size: 0
> [   82.442360] efi:  size': 1039
> [   82.443828] efi: size: 0
> [   82.444127] efi:  size': 2616
> [   82.447057] efi: size: 0
> [   82.447356] efi:  size': 5832
> ...
> 
> Found on Acer Aspire V3 BIOS, it will not return the size of data if we input a
> non-zero DataSize.
> 
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  arch/x86/platform/efi/efi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
