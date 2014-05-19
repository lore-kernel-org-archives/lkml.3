Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaESPx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:53:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:52828 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaESPx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:53:56 -0400
X-IronPort-AV: E=Sophos;i="4.98,868,1392163200"; 
   d="scan'208";a="133190233"
Message-ID: <537A28F8.4030707@citrix.com>
Date: Mon, 19 May 2014 16:53:28 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>
CC: <boris.ostrovsky@oracle.com>, <eshelton@pobox.com>, <hpa@zytor.com>,
        <ian.campbell@citrix.com>, <jbeulich@suse.com>, <jeremy@goop.org>,
        <konrad.wilk@oracle.com>, <matt.fleming@intel.com>, <mingo@redhat.com>,
        <mjg59@srcf.ucam.org>, <stefano.stabellini@eu.citrix.com>,
        <tglx@linutronix.de>
Subject: Re: [PATCH v4 0/5] xen: Add EFI support
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/14 21:41, Daniel Kiper wrote:
> Hey,
> 
> This patch series adds EFI support for Xen dom0 guests.
> It is based on Jan Beulich and Tang Liang work. I was
> trying to take into account all previous comments,
> however, if I missed something sorry for that.

There needs to be a better description of this series.  In particular, a
description of why Xen PV guests are different and the overall design used.

> I am still not sure what to do with /sys/firmware/efi/config_table,
> /sys/firmware/efi/{fw_vendor,runtime,systab} files. On bare metal
> they contain physical addresses of relevant structures. However,
> in Xen case they does not make sens. So maybe they should contain
> invalid values (e.g. 0) or should not appear at all on Xen (I prefer
> last one). What do you think about that?

Generally, dom0 has provided access to BIOS provided data structures.  I
think you should do the same here.  They may be useful for diagnostics
if nothing else.

David
