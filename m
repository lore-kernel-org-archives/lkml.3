Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbaDITPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:15:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34907 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933323AbaDITPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:15:01 -0400
Date: Wed, 9 Apr 2014 21:14:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jason Baron <jbaron@akamai.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Aristeu Rozanski <aris@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
Message-ID: <20140409191454.GQ6529@pd.tnic>
References: <cover.1396645124.git.jbaron@akamai.com>
 <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com>
 <20140409113552.GJ6529@pd.tnic>
 <20140409133433.GJ29214@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com>
 <20140409173633.GN6529@pd.tnic>
 <5345980F.7070604@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5345980F.7070604@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 02:57:19PM -0400, Jason Baron wrote:
> Right, so maybe the fact that its a desktop chipset means that it
> behaves differently and doesn't raise MCEs on memory errors. We have a
> bunch of these processors and we haven't yet seen an MCE raised on a
> memory error.

This can't be - an uncorrectable error will have to generate a machine
check exception if consumed - there's no other option.

Can you do

rdmsr 0x179
rdmsr 0x17b

and paste the results here?

> The reason I went with ie31200 is that afaiu the memory controller hub
> is integrated into the cpu. Another alternative might be ie312xx?

Yeah, if Tony doesn't come up with something more official about that
MCH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
