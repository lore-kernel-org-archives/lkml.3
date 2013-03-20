Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab3CTCsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 22:48:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42888 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3CTCsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 22:48:35 -0400
Message-ID: <51492379.3090302@zytor.com>
Date: Tue, 19 Mar 2013 19:48:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
References: <3pfl8u1ugprwkcs5xmtjth3l.1363742692541@email.android.com>
In-Reply-To: <3pfl8u1ugprwkcs5xmtjth3l.1363742692541@email.android.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 06:28 PM, Matthew Garrett wrote:
> Mm. The question is whether we can reliably determine the ranges a device should be able to access without having to trust userspace (and, ideally, without having to worry about whether iommu vendors have done their job). It's pretty important for PCI passthrough, so we do need to care. 

It is actually very simple: the device should be able to DMA into/out of:

1. pinned pages
2. owned by the process controlling the device

... and nothing else.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

