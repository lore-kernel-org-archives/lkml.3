Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3J2KMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:12:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3J2KMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:12:16 -0400
Date: Tue, 29 Oct 2013 12:11:56 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/6] kvm, emulator: Add initial three-byte insns support
Message-ID: <20131029101156.GX15657@redhat.com>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <1379861095-628-5-git-send-email-bp@alien8.de>
 <20131029095043.GV15657@redhat.com>
 <20131029100457.GC10972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029100457.GC10972@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:04:57AM +0100, Borislav Petkov wrote:
> On Tue, Oct 29, 2013 at 11:50:43AM +0200, Gleb Natapov wrote:
> > There are two three opcode tables, so third_opcode_byte is ambiguous.
> 
> Actually there's also 0F_3A and there are also other prefixes besides f0
> and f1. Oh, and those tables are not completely full so I can imagine
> more stuff coming in later....
> 
> I know what you're thinking by now, btw :-)
> 
:)

> > What about pfx_0f_38_f0 and pfx_0f_38_f1?
> 
> Yeah, those make it much more explicit.
> 
> I wanted to keep the "three_byte" in the name in there somewhere,
> though, so that it is clear that we're dealing with three byte opcodes
> instead of requiring the onlooking innocent person to know the opcodes.
> 
> How about:
> 
> three_byte_0f_38_f0
> three_byte_0f_38_f1
> three_byte_0f_3a_50
> ...
> 
> Last one is an example only.
> 
Looks OK to me.

> Btw, we might want to reconsider that whole tabular representation when
> more stuff needs to be added...
> 
Of course. When tables will start to show their limitation we can always
change to something else.

--
			Gleb.
