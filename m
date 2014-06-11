Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaFKIzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:55:53 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36160 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaFKIzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:55:50 -0400
Date: Wed, 11 Jun 2014 09:55:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Russ Anderson <rja@sgi.com>
Subject: Re: [RFC] Best place/method to determine BIOS version?
Message-ID: <20140611085548.GB26290@console-pimps.org>
References: <20140609200017.GD2700@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609200017.GD2700@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun, at 03:00:17PM, Alex Thorlton wrote:
> 
> I think the problem is that I really need to be doing this at a point
> where I can directly use physical addressing (the function pointer that
> we have stored in efi.uv_systab contains the physical address of our
> function) - at least that's the idea I get from our BIOS guys, but I
> really don't know what I'm talking about here :)

Can't you use either early_ioremap() or ioremap() (depending on when you
want to access the physical address), perhaps coupled with
efi_call_phys()?

-- 
Matt Fleming, Intel Open Source Technology Center
