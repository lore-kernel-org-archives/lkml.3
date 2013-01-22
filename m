Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3AVPz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:55:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34429 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab3AVPzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:55:25 -0500
Message-ID: <50FEB620.3020805@zytor.com>
Date: Tue, 22 Jan 2013 09:54:08 -0600
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: yinghai@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, vgoyal@redhat.com, horms@verge.net.au
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump
 usage
References: <1358868049-19884-1-git-send-email-trenn@suse.de> <1358868049-19884-3-git-send-email-trenn@suse.de>
In-Reply-To: <1358868049-19884-3-git-send-email-trenn@suse.de>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 09:20 AM, Thomas Renninger wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> kdump voided the whole original e820 map and half way made
> it up via memmap= options passed via kdump boot params again.
> 
> But this is conceptionally wrong. The whole original memory ranges
> which are declared reserved, ACPI data/nvs or however are not usable
> must stay the same and get honored by the kdump kernel.
> 
> Therefore memmap=resetusablemap gets introduced.
> kdump passes this one and only the usable e820 ranges are removed.
> kdump passes the usable ranges to use via memmap=x@y parameter(s).
> The not usable e820 ranges are preserved.
> 
> This for example fixes mmconf (extended PCI config access) and
> possibly other kernel parts which rely on remapped memory to be
> in reserved or ACPI (data/nvs) declared e820 memory areas.
> 
> Tested-by: Thomas Renninger <trenn@suse.de>
> Reviewed-by: Thomas Renninger <trenn@suse.de>
> Signed-off-by: Thomas Renninger <trenn@suse.de>

Tested-by: and Reviewed-by: are rather redundant with Signed-off-by:.
Also, you should have a Signed-off-by: from the author (Yinghai).

However, when thinking about it this really doesn't seem to be the right
interface, either.  Something like "memmap=reserveram" which turns all
RAM areas into reserved areas, which can then be overridden by memmap=
options would make more sense.

Even more sense would be to pass the modified memmap to kexec...

	-hpa


