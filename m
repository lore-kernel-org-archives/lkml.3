Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaKXVuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:50:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37309 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaKXVud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:50:33 -0500
Date: Mon, 24 Nov 2014 21:50:26 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH 1/3] platform: x86: dell-rbtn: Dell Airplane Mode Switch
 driver
Message-ID: <20141124215026.GA14361@srcf.ucam.org>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
 <1416755361-17357-2-git-send-email-pali.rohar@gmail.com>
 <20141124200905.GB3459@srcf.ucam.org>
 <201411242155.48087@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411242155.48087@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 09:55:47PM +0100, Pali Rohár wrote:

> This is complicated. HW switch controls all radio devices and you 
> do not know which are present in specified running machine. Also 
> list of devices which HW switch controls can be edited in BIOS 
> (on some machines). So what to do? We only know that it controls 
> some devices...

Typically there'll be a firmware method that provides a mask of the 
controlled devices. Do you have the ACPI tables for a device that 
implements this? Registering an rfkill interface that claims to only 
control wifi but which also kills other devices is likely to confuse 
userspace - it would probably be better to avoid registering the rfkill 
interface at all in that case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
