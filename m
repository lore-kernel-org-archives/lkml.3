Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906Ab3LIRCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:02:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44804 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3LIRCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:02:19 -0500
Date: Mon, 9 Dec 2013 17:02:14 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Vcelak <jan.vcelak@nic.cz>
Cc: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: full battery charge cannot exceed current one
Message-ID: <20131209170214.GB30717@srcf.ucam.org>
References: <1386419801-10091-1-git-send-email-jan.vcelak@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386419801-10091-1-git-send-email-jan.vcelak@nic.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 01:36:41PM +0100, Jan Vcelak wrote:
> Some degraded batteries report maximal capacity to be smaller than
> current charge of the battery. This can confuse some user space
> applications (like upower).

Can't we just fix upower?

> +
> +	/* Some degraded batteries report lower full charge than current one. */
> +	if (battery->capacity_now > battery->full_charge_capacity)
> +		battery->full_charge_capacity = battery->capacity_now;
> +

Does upower read *_full on every read of the value? How do we guarantee 
that it won't read energy_now without updating energy_full and still 
come up with an incorrect calculation?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
