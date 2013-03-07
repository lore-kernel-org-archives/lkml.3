Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748Ab3CGUjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:39:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59942 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab3CGUjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:39:11 -0500
Message-ID: <5138FAD9.7050504@zytor.com>
Date: Thu, 07 Mar 2013 12:38:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 09:40 AM, Seth Forshee wrote:
> We know that with some firmware implementations writing too much data to
> UEFI variables can lead to bricking machines. Recent changes attempt to
> address this issue, but for some it may still be prudent to avoid
> writing large amounts of data until the solution has been proven on a
> wide variety of hardware.
> 
> Crash dumps or other data from pstore can potentially be a large data
> source. Add a new option, CONFIG_EFI_VARS_PSTORE, which can be set to N
> to avoid using efivars as a backend to pstore.

What about a command line option?

> -#ifdef CONFIG_PSTORE
> +#if defined(CONFIG_PSTORE) && defined(CONFIG_EFI_VARS_PSTORE)

Redundant.

	-hpa

