Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaJ1WHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:07:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60453 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaJ1WHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:07:36 -0400
Date: Tue, 28 Oct 2014 23:07:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mathias Krause <minipli@googlemail.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141028220731.GI10873@pd.tnic>
References: <20141008151730.GB16892@pd.tnic>
 <CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
 <20141008222619.GG16892@pd.tnic>
 <20141012125515.GA32045@jig.fritz.box>
 <20141028185756.GD10873@pd.tnic>
 <CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
 <20141028201342.GG10873@pd.tnic>
 <CA+rthh9LSRm12qYORAd5BWzpw7DEP7hqHLA3EDdfUDxwx-4=2g@mail.gmail.com>
 <20141028212642.GH10873@pd.tnic>
 <CA+rthh-Tk3PO0qUeyLzxggCYOhr5D4EvPjKR+jhmjdPXi4yu=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+rthh-Tk3PO0qUeyLzxggCYOhr5D4EvPjKR+jhmjdPXi4yu=Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:49:36PM +0100, Mathias Krause wrote:
> Sync only data or kernel code, too?

Data only should be enough.

> Really, I'd just map the EFI RT service virtual mappings "somewhere"
> but at pgd[511] and have pgd[511] initially set up as
> init_level4_pgt[511]. Then, thing should "just work"(TM).

Nah, nothing with EFI just works :-)

> If you fear the EFI code might do harm to the kernel code/data, then
> you've lost anyway. Nothing will prevent the EFI code from doing nasty
> things -- like setting up its own mappings to tamper with the kernel's
> memory.

Sure, nothing would surprise me anymore. However, I'd prefer to not be
an enabler. :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
