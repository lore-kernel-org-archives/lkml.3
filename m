Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3CGIjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:39:37 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33145 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3CGIjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:39:36 -0500
Message-ID: <1362645561.15011.104.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] Be explicit about what the x86 0x020c boot parameter
 version requires.
From: Matt Fleming <matt.fleming@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Jones <pjones@redhat.com>, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 08:39:21 +0000
In-Reply-To: <5138180B.3010503@zytor.com>
References: <51377C3A.3030301@zytor.com>
	 <1362592823-28967-1-git-send-email-pjones@redhat.com>
	 <5138180B.3010503@zytor.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 20:31 -0800, H. Peter Anvin wrote:
> On 03/06/2013 10:00 AM, Peter Jones wrote:
> > This should help avoid making the incorrect change in non-compliant
> > bootloaders.
> > 
> > Signed-off-by: Peter Jones <pjones@redhat.com>
> > ---
> >  Documentation/x86/boot.txt             | 5 +++--
> >  arch/x86/include/asm/bootparam_utils.h | 7 +++++++
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> > index 3840b6f..72702db 100644
> > --- a/Documentation/x86/boot.txt
> > +++ b/Documentation/x86/boot.txt
> > @@ -1110,7 +1110,8 @@ firmware, 'table' is the EFI system table - these are the first two
> >  arguments of the "handoff state" as described in section 2.3 of the
> >  UEFI specification. 'bp' is the boot loader-allocated boot params.
> >  
> > -The boot loader *must* fill out the following fields in bp,
> > +The boot loader *must* zero the entirity of bp, and then fill out the
> > +following fields:
> >  
> >      o hdr.code32_start
> >      o hdr.cmd_line_ptr
> > @@ -1118,4 +1119,4 @@ The boot loader *must* fill out the following fields in bp,
> >      o hdr.ramdisk_image (if applicable)
> >      o hdr.ramdisk_size  (if applicable)
> >  
> 
> Wait a bloody minute here... I seem to have managed to miss something big.
> 
> Matt, should we not be copying the setup part of the structure just as
> we do for the normal 32/64-bit protocol?  If not, why not?

The structure that contains the hdr.version? Yeah, we should be copying
that.


