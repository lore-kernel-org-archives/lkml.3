Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3EMTVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:21:53 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56240 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3EMTVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:21:51 -0400
Message-ID: <51913D4B.2000606@intel.com>
Date: Mon, 13 May 2013 20:21:47 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lingzhu Xiang <lxiang@redhat.com>
CC: Jeremy Kerr <jk@ozlabs.org>, Matthew Garrett <matthew.garrett@nebula.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] efivarfs: Never return ENOENT from firmware again
References: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>
In-Reply-To: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 11:29 AM, Lingzhu Xiang wrote:
> Previously in 1fa7e69 efi_status_to_err() translated firmware status
> EFI_NOT_FOUND to -EIO instead of -ENOENT for efivarfs operations to
> avoid confusion. After refactoring in e14ab23, it is also used in other
> places where the translation may be unnecessary.
> 
> So move the translation to efivarfs specific code. Also return EOF
> for reading zero-length files, which is what users would expect.
> 
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: Jeremy Kerr <jk@ozlabs.org>
> Cc: Lee, Chun-Yi <jlee@suse.com>
> Cc: Andy Whitcroft <apw@canonical.com>
> Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
> ---
> This is to be applied against mainline or Matt Fleming's chainsaw branch.

Applied, thanks.

FYI, I rebased my 'urgent' branch on v3.10-rc1, so your patch now
applies there too.

