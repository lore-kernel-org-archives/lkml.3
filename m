Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab3CSBsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:48:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39283 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3CSBsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:48:54 -0400
Date: Tue, 19 Mar 2013 01:48:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Message-ID: <20130319014850.GA28934@srcf.ucam.org>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 08:40:14AM +0000, James Bottomley wrote:

> The object here is to make the NV+BS variables accessible (at least read only)
> at runtime so we can get a full picture of the state of the EFI variables for
> debugging and secure boot purposes.

I'd really prefer not to do this - the reason these aren't flagged as RT 
is that they're not supposed to be visible at runtime and may break 
certain security assumptions. If there's a real development purpose to 
this then it ought to be guarded as a config option.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
