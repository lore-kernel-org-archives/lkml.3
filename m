Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab3BTLUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:20:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44914 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902Ab3BTLUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:20:39 -0500
Date: Wed, 20 Feb 2013 12:20:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 3/6] edac: put all arguments for the raw error
 handling call into a struct
Message-ID: <20130220112036.GC16775@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1361358127.git.mchehab@redhat.com>
 <8558ae9a99b90c1c1275f66ebd363edf27064845.1361358127.git.mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8558ae9a99b90c1c1275f66ebd363edf27064845.1361358127.git.mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 08:12:49AM -0300, Mauro Carvalho Chehab wrote:
> The number of arguments for edac_raw_mc_handle_error() is too big;
> put them into a structure and allocate space for it inside
> edac_mc_alloc().
> 
> That reduces a lot the stack usage and simplifies the raw API call.
> 
> Tested with sb_edac driver and MCE error injection. Worked as expected:
> 
> [  143.066100] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
> [  143.086424] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
> [  143.106570] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
> [  143.126712] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Looks ok.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
