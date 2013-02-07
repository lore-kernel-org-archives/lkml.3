Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab3BGDLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:11:35 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:60533 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab3BGDLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:11:34 -0500
MIME-Version: 1.0
In-Reply-To: <5fc782f401fc7bb0cd829b2316d7f29eb2595036.1360206266.git.luto@amacapital.net>
References: <5fc782f401fc7bb0cd829b2316d7f29eb2595036.1360206266.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 6 Feb 2013 19:11:12 -0800
Message-ID: <CALCETrXQ5T5h8zX9XW_7oorpvPKYpMQHxoOARKEr-TcVEMcHrA@mail.gmail.com>
Subject: Re: [PATCH] intel_iommu: Disable vfio and kvm interrupt assignment
 when unsafe
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 7:08 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> We currently report IOMMU_CAP_INTR_REMAP whenever interrupt remapping
> is enabled.  Users of that capability expect it to mean that remapping
> is secure (i.e. compatibility format interrupts are blocked).  Explicitly
> check whether CFIs are blocked and, if not, don't report the capability.

FWIW, I've wanted a feature IOMMU_CAP_SECURE that means that all DMA
and MSI from the domain is secure (i.e. only does what is explicitly
requested via the iommu api).  The current situation is hard to
understand, as evidenced by the iommu type 1 stuff in vfio.  But I
don't even understand what an iommu group is, and I've read a decent
chunk of the code.  But that's not really relevant to this patch.

--Andy
