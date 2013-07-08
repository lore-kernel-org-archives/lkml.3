Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3GHPhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:37:03 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51196 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3GHPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:37:00 -0400
Message-ID: <1373297814.24233.5.camel@x230.lan>
Subject: Re: [PATCH] platform samsung-q10: use ACPI instead of direct EC
 calls
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frederick van der Wyck <fvanderwyck@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Date: Mon, 08 Jul 2013 11:36:54 -0400
In-Reply-To: <20130703212737.GC5579@lat.lan>
References: <20130703212737.GC5579@lat.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:7596:9e59:a1e6:6b6c
X-SA-Exim-Mail-From: mjg59@srcf.ucam.org
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 22:27 +0100, Frederick van der Wyck wrote:

> +#define EC_HID "PNP0C09"

This is probably wrong - you should be able to just use first_ec
directly rather than probing yourself.
> +	for (i = 0; i < SAMSUNGQ10_BL_MAX_INTENSITY; i++) {
> +		status = acpi_evaluate_object(ec_handle, "_Q63", NULL, NULL);

The potential problem here is that there's no guarantee that these event
numbers are stable, and a firmware upgrade could change them. Of course,
that's also true of the EC registers, but we haven't had anyone complain
about the driver suddenly breaking so I'm not hugely enthusiastic about
replacing one fragile but seemingly working method with a fragile but
unproven one. 

-- 
Matthew Garrett <mjg59@srcf.ucam.org>

