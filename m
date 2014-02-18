Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaBRSoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:44:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaBRSob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:44:31 -0500
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, devel@acpica.org,
        mingo@redhat.com, ck@conrad-kostecki.de, tglx@linutronix.de,
        rjw@rjwysocki.net
Subject: Re: [PATCH 1/4] ACPI: Provide support for ACPI table adding via OS
Date: Tue, 18 Feb 2014 19:44:26 +0100
Message-ID: <1568883.1dLS7uNIC1@skinner>
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <7af8855f-8055-467c-89c0-bcab453f3969@email.android.com>
References: <530265A3.3020302@zytor.com> <1392747763-3384-2-git-send-email-trenn@suse.de> <7af8855f-8055-467c-89c0-bcab453f3969@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 10:27:23 AM H. Peter Anvin wrote:
> Why can't you add SSDTs? It would be particularly useful.

There are 2 ways how ACPI tables get added:
   - Via pointer from a root table (XSDT or RSDT iirc)
   - Via load statement inside of ACPI context when ACPI BIOS
     code gets executed (iirc the physical address is passed).

The latter is only for SSDTs.
The problem is that you if you add an SSDT early, it might
have been intended for overriding when an SSDT gets dynamically
loaded later when the system is up which is particular useful as
well if you want to debug this specific BIOS table.

This could be workarounded via a boot param:
acpi=allow_ssdt_adding
But this is not nice. Maybe someone has a more elegant idea.
Something could still be added if someone is really needing this.

     Thomas
