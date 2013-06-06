Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab3FFNXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:23:31 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46943 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3FFNXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:23:30 -0400
Message-ID: <51B08D4E.7020806@intel.com>
Date: Thu, 06 Jun 2013 14:23:26 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UEFI: Don't pass boot services regions to SetVirtualAddressMap()
References: <1370211145-7273-1-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1370211145-7273-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/13 23:12, Matthew Garrett wrote:
> We need to map boot services regions during startup in order to avoid
> firmware bugs, but we shouldn't be passing those regions to
> SetVirtualAddressMap(). Ensure that we're only passing regions that are
> marked as being mapped at runtime.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  arch/x86/platform/efi/efi.c | 7 +++++++
>  1 file changed, 7 insertions(+)

This doesn't fix a crash or regression, right? If it's a "this just
makes more sense" patch, I'll queue it up in the 'next' branch for
v3.11.
