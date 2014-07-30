Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaG3OsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:48:10 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59805 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaG3OsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:48:08 -0400
Date: Wed, 30 Jul 2014 15:48:03 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Message-ID: <20140730144803.GB15082@console-pimps.org>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
 <20140729222932.GA17481@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729222932.GA17481@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul, at 12:29:32AM, Borislav Petkov wrote:
> On Tue, Jul 29, 2014 at 01:09:21PM -0400, Prarit Bhargava wrote:
> > The current debug print in EFI does
> > 
> > [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (0MB)
> > 
> > and rounds off the size to 0MB and isn't very useful.  We should print this in
> > Kib.  After applying this patch we get better info with
> > 
> > [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (280kiB)
> 
> Turning this into kiB unconditionally won't always work ok:
> 
> First of all, there might be something which parses that output so I'd
> make sure I'm not breaking that. Maybe fwts... Matt will know.

I'm not aware of anything that parses the dmesg output, but I'm
including Colin in case he has any insight.

-- 
Matt Fleming, Intel Open Source Technology Center
