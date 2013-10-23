Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3JWNLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:11:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37479 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab3JWNLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:11:13 -0400
Date: Wed, 23 Oct 2013 15:11:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131023131113.GA16432@nazgul.tnic>
References: <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
 <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
 <20131021133741.GA5716@nazgul.tnic>
 <20131021150426.GB4515@dhcp-16-126.nay.redhat.com>
 <20131022111857.GA10660@nazgul.tnic>
 <20131023021730.GE4594@dhcp-16-126.nay.redhat.com>
 <20131023122531.GA15848@nazgul.tnic>
 <20131023125131.GA5552@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131023125131.GA5552@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 08:51:31PM +0800, Dave Young wrote:
> In kexed 2nd kernel, phys_start_b need to be mapped to virt_start_b
> Simply use efi_map_region from your patch does not work because it
> will map phys_start_b to a different virt address, isn't it?

Oh ok, in the second kernel we're not mapping *all* regions we do map in
the first kernel, right.

> So I need simply map according to the kexec passed in mapping addr.

Yes, thanks for elaborating.
