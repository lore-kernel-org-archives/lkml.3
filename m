Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3HLR4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:56:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39036 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab3HLR4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:56:35 -0400
Date: Mon, 12 Aug 2013 19:56:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130812175631.GI18018@pd.tnic>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com>
 <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com>
 <20130812123813.GD18018@pd.tnic>
 <20130812114932.52bb0314@samsung.com>
 <20130812150424.GH18018@pd.tnic>
 <20130812142557.2a43f155@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130812142557.2a43f155@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 02:25:57PM -0300, Mauro Carvalho Chehab wrote:
> Userspace still needs the EDAC sysfs, in order to identify how the
> memory is organized, and do the proper memory labels association.
>
> What edac_ghes does is to fill those sysfs nodes, and to call the
> existing tracing to report errors.

This is the only reason which justifies EDAC's existence. Naveen, can
your BIOS directly report the silkscreen label of the DIMM in error?
Generally, can any BIOS do that?

More specifically, what are those gdata_fru_id and gdata_fru_text
things?

Because if it can, then having the memory error tracepoint come direct
from APEI should be enough. The ghes_edac functionality could be then
fallback for BIOSes which cannot report the silkscreen label and in such
case I can imagine keeping both tracepoints, but disabling one of the
two...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
