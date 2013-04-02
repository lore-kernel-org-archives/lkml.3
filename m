Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3DBQSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:18:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52198 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761097Ab3DBQSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:18:03 -0400
Date: Tue, 2 Apr 2013 18:17:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402161757.GC17519@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joerg Roedel <joro@8bytes.org>, suravee.suthikulpanit@amd.com,
	iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130402143335.GB15687@8bytes.org>
 <20130402144037.GE5488@pd.tnic>
 <20130402150302.GF15687@8bytes.org>
 <20130402152956.GE4391@pd.tnic>
 <20130402160400.GP30540@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130402160400.GP30540@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 06:04:00PM +0200, Joerg Roedel wrote:
> I can certainly write a patch that works around your particular BIOS
> bug. The problem is that such a fix will most certainly break other
> systems.
>
> Unfortunatly there is no reliable way to fixup the IO-APIC-ID->DEVID
> mapping at runtime when the BIOS messed it up. The only thing I can do
> is to check for potential problems and disable the intremap feature
> then, so that the system will at least boot.

Yeah, that could work:

* do not issue message but try to fixup the mapping
* if it works, fine
* if it doesn't, then give up and disable intremap.

And yes, I'm very sceptical about having a WARN_ON and it starts
screaming on machines all over the place. Good luck explaining to
people that you actually wanted to prod BIOS vendors to fix their
monkey-on-crack code but they weren't listening in the first place.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
