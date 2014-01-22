Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbaAVSFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:05:23 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59314 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755678AbaAVSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:05:17 -0500
Date: Wed, 22 Jan 2014 18:04:43 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 4/6] arm64: add EFI stub
Message-ID: <20140122180443.GF8065@arm.com>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
 <1389392950-22457-5-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389392950-22457-5-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:29:08PM +0000, Mark Salter wrote:
> +ENTRY(efi_stub_entry)
> +       stp     x29, x30, [sp, #-32]!
> +
> +       /*
> +        * Call efi_entry to do the real work.
> +        * x0 and x1 are already set up by firmware. Current runtime
> +        * address of image is calculated and passed via *image_addr.
> +        *
> +        * unsigned long efi_entry(void *handle,
> +        *                         efi_system_table_t *sys_table,
> +        *                         unsigned long *image_addr) ;
> +        */
> +       adrp    x8, _text
> +        add    x8, x8, #:lo12:_text

Possibly some minor whitespace corruption (or it's our email server).

-- 
Catalin
