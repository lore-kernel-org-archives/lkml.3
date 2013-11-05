Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3KEKS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 05:18:26 -0500
Received: from canardo.mork.no ([148.122.252.1]:39589 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3KEKSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 05:18:24 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Julian Andres Klode <jak@jak-linux.org>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net (open list:THINKPAD ACPI EXT...),
        platform-driver-x86@vger.kernel.org (open list:THINKPAD ACPI EXT...),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [RFC PATCH] thinkpad_acpi: Add support for controlling charge thresholds
Organization: m
References: <1383601088-21177-1-git-send-email-jak@jak-linux.org>
Date: Tue, 05 Nov 2013 11:18:02 +0100
In-Reply-To: <1383601088-21177-1-git-send-email-jak@jak-linux.org> (Julian
	Andres Klode's message of "Mon, 4 Nov 2013 22:38:08 +0100")
Message-ID: <87ppqfrw2t.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julian Andres Klode <jak@jak-linux.org> writes:

>  
> +TPACPI_HANDLE(battery, root, "\\_SB.PCI0.LPC.EC.HKEY",
> +	   "\\_SB.PCI0.LPCB.EC.HKEY",		/* X121e, T430u */
> +	   "\\_SB.PCI0.LPCB.H_EC.HKEY",		/* L430 */
> +	   "\\_SB.PCI0.LPCB.EC0.HKEY",		/* Edge/S series */
> +	   );
> +

Isn't this just the full patch to the existing "hkey_handle" for those
models?  Why not just use that handle, like e.g the rfkill driver does?

Supported models could probably be autodetected by checking whether the
methods exist?

> +static struct attribute_group bat##_BAT##_attribute_group = { \
> +	.name  = "BAT" #_BAT, \
> +	.attrs = bat##_BAT##_attributes \
> +};

Are these names guaranteed to match the ACPI battery device(s)?

> +DEFINE_BATTERY(0);
> +DEFINE_BATTERY(1);

Are there always two batteries?



Bjørn
