Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3JVLTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:19:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58657 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab3JVLS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:18:58 -0400
Date: Tue, 22 Oct 2013 13:18:57 +0200
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
Message-ID: <20131022111857.GA10660@nazgul.tnic>
References: <20131011074144.GA18719@pd.tnic>
 <20131012075443.GD7550@dhcp-16-126.nay.redhat.com>
 <20131012101308.GI12321@console-pimps.org>
 <20131012103054.GA13739@pd.tnic>
 <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
 <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
 <20131021133741.GA5716@nazgul.tnic>
 <20131021150426.GB4515@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131021150426.GB4515@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 11:04:26PM +0800, Dave Young wrote:
> > You need this to map the runtime regions in the kexec kernel, right?
> > Please write that in the commit message.
> 
> Yes, will do

Ok, but but, why doesn't the normal code path in efi_enter_virtual_mode
work anymore? I mean, why do you need another function instead of doing
what you did previously:

	if (!kexec)
		phys_efi_set_virtual_address_map(...)

The path up to here does the mapping already anyway so you only need to
do the mapping in the kexec kernel and skip set set_virtual_map thing.

Thanks.
