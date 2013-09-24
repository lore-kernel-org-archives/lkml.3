Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3IXO45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:56:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50275 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab3IXO44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:56:56 -0400
Message-ID: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
Date: Tue, 24 Sep 2013 16:56:49 +0200 (CEST)
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
From: "Borislav Petkov" <bp@alien8.de>
To: "Dave Young" <dyoung@redhat.com>
Cc: "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "X86 ML" <x86@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <bp@suse.de>,
        "Matt Fleming" <matt@console-pimps.org>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>,
        "James Bottomley" <james.bottomley@hansenpartnership.com>,
        "Vivek Goyal" <vgoyal@redhat.com>, linux-efi@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, September 24, 2013 2:45 pm, Dave Young wrote:
> Think again about this, how about 1:1 map them from a base address
> like -64G phy_addr -> (-64G + phy_addr), in this way we can avoid
> depending on the previous region size.

Right, how we layout the regions is arbitrary as long as we start at
the same VA and use the same regions, in the same order and of the same
size...

> For the zero region problem, we can resolve it as a standalone
> problem.

... however, we still need to understand why it fails mapping the boot
services region as some implementations apparently do call boot services
even after ExitBootServices(). IOW, we need that region mapped in the
kexec'ed kernel too.

Thanks.

-- 
Regards/Gruss,
Boris.

