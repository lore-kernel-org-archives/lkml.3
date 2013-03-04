Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab3CDUYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:24:54 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:59621 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab3CDUYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:24:52 -0500
Message-ID: <1362428688.15011.1.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efi: be more paranoid about available space when
 creating variables
From: Matt Fleming <matt.fleming@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Date: Mon, 04 Mar 2013 20:24:48 +0000
In-Reply-To: <1362271217-31747-1-git-send-email-matthew.garrett@nebula.com>
References: <1362271217-31747-1-git-send-email-matthew.garrett@nebula.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 19:40 -0500, Matthew Garrett wrote:
> UEFI variables are typically stored in flash. For various reasons, avaiable
> space is typically not reclaimed immediately upon the deletion of a
> variable - instead, the system will garbage collect during initialisation
> after a reboot.
> 
> Some systems appear to handle this garbage collection extremely poorly,
> failing if more than 50% of the system flash is in use. This can result in
> the machine refusing to boot. The safest thing to do for the moment is to
> forbid writes if they'd end up using more than half of the storage space.
> We can make this more finegrained later if we come up with a method for
> identifying the broken machines.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/firmware/efivars.c | 106 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 79 insertions(+), 27 deletions(-)

Thanks, applied and marked for stable.


