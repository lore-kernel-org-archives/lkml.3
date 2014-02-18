Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaBRUxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:53:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46322 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaBRUxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:53:41 -0500
Message-ID: <5303C7BB.4020803@zytor.com>
Date: Tue, 18 Feb 2014 12:51:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, devel@acpica.org,
        mingo@redhat.com, ck@conrad-kostecki.de, tglx@linutronix.de,
        rjw@rjwysocki.net
Subject: Re: [PATCH 1/4] ACPI: Provide support for ACPI table adding via OS
References: <530265A3.3020302@zytor.com> <1392747763-3384-2-git-send-email-trenn@suse.de> <7af8855f-8055-467c-89c0-bcab453f3969@email.android.com> <1568883.1dLS7uNIC1@skinner>
In-Reply-To: <1568883.1dLS7uNIC1@skinner>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 10:44 AM, Thomas Renninger wrote:
> On Tuesday, February 18, 2014 10:27:23 AM H. Peter Anvin wrote:
>> Why can't you add SSDTs? It would be particularly useful.
> 
> There are 2 ways how ACPI tables get added:
>    - Via pointer from a root table (XSDT or RSDT iirc)
>    - Via load statement inside of ACPI context when ACPI BIOS
>      code gets executed (iirc the physical address is passed).
> 
> The latter is only for SSDTs.
> The problem is that you if you add an SSDT early, it might
> have been intended for overriding when an SSDT gets dynamically
> loaded later when the system is up which is particular useful as
> well if you want to debug this specific BIOS table.
> 
> This could be workarounded via a boot param:
> acpi=allow_ssdt_adding
> But this is not nice. Maybe someone has a more elegant idea.
> Something could still be added if someone is really needing this.

Since adding SSDTs is one of the things I really can imagine one would
do, I think we need to figure out how to do that.  I would think that
overriding would be the exception case.

	-hpa

