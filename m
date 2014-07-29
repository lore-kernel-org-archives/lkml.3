Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaG2W3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:29:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52144 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaG2W3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:29:38 -0400
Date: Wed, 30 Jul 2014 00:29:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Message-ID: <20140729222932.GA17481@pd.tnic>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406653761-3884-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 01:09:21PM -0400, Prarit Bhargava wrote:
> The current debug print in EFI does
> 
> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (0MB)
> 
> and rounds off the size to 0MB and isn't very useful.  We should print this in
> Kib.  After applying this patch we get better info with
> 
> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (280kiB)

Turning this into kiB unconditionally won't always work ok:

First of all, there might be something which parses that output so I'd
make sure I'm not breaking that. Maybe fwts... Matt will know.

Then, I have an UEFI region which is > 13G:

[    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x0000000450000000) (13568MB)


With your patch it is even worse:

[    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x0000000450000000) (13893632kiB)


I'd guess you'll have to go all out and do this properly. :-)

Something like showing the highest unit which is still > 1. In the above
case, this should be (13GB) or maybe even introduce fractions.

Depends on how involved this output should be.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
