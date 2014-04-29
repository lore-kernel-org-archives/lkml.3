Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbaD2TO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:14:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50411 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaD2TO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:14:58 -0400
Date: Tue, 29 Apr 2014 21:14:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Borislav Petkov <bp@suse.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Robert Richter <rric@kernel.org>,
        Myron Stowe <myron.stowe@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>, kim.naru@amd.com,
        Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range
 capabilities
Message-ID: <20140429191454.GB4726@pd.tnic>
References: <20140419025323.2408.88764.stgit@amt.stowe>
 <20140419135219.GC8109@pd.tnic>
 <20140420075936.GA19672@pd.tnic>
 <CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com>
 <20140426091031.GA10166@pd.tnic>
 <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
 <20140428214036.GA32143@pd.tnic>
 <20140429073309.GE10997@alberich>
 <20140429102013.GA4726@pd.tnic>
 <535FC269.2000808@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <535FC269.2000808@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:16:57AM -0500, Suravee Suthikulanit wrote:
> In the new code, the IO ECS was needed to retrieve the
> AMD_NB_F1_MMIO_BASE_LIMIT_HI_REG (offset 0x180) during the early
> initialization as part of (2) logic. However, this register exists only on
> the newer systems.  However, as you mentioned, for (2) we can assume that
> the MCFG exists for most of the systems (family10h and later), and should be
> used instead.
> 
> The main purpose of this patch set is mainly to deal with the the node
> information (1).  So, we might need to split these all up and handle them
> separately as needed where (2) and (3) will be used as fallback for older
> systems where MCFG does not exist.

So sounds to me like we want to get rid of the whole IO ECS deal
altogether then.

Now, I'm wondering whether we should kill it completely since I don't
think anyone cares about numa node info being correct on K8, or? I'm
specifically turning to our numascale friends who love to have a lot of
nodes. :-)

Daniel, Steffen?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
