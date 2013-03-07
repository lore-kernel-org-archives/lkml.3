Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820Ab3CGU7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:59:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49563 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3CGU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:59:28 -0500
Date: Thu, 7 Mar 2013 14:59:15 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Message-ID: <20130307205915.GF24233@thinkpad-t410>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	Matt Fleming <matt.fleming@intel.com>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
 <5138FAD9.7050504@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5138FAD9.7050504@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 12:38:49PM -0800, H. Peter Anvin wrote:
> On 03/07/2013 09:40 AM, Seth Forshee wrote:
> > We know that with some firmware implementations writing too much data to
> > UEFI variables can lead to bricking machines. Recent changes attempt to
> > address this issue, but for some it may still be prudent to avoid
> > writing large amounts of data until the solution has been proven on a
> > wide variety of hardware.
> > 
> > Crash dumps or other data from pstore can potentially be a large data
> > source. Add a new option, CONFIG_EFI_VARS_PSTORE, which can be set to N
> > to avoid using efivars as a backend to pstore.
> 
> What about a command line option?

That could be done. I'm assuming you want this instead of a config
option, defaulted to on?

How would you feel about a config option for the default value of the
command line option? I intend to default this to off in Ubuntu for a
while as a colleague's machine was recently bricked on two different
occasions after the kernel oopsed. The config option would simplify
things a bit for us, though we could always carry a patch changing the
default value.

> > -#ifdef CONFIG_PSTORE
> > +#if defined(CONFIG_PSTORE) && defined(CONFIG_EFI_VARS_PSTORE)
> 
> Redundant.

Yes, good point.

Thanks,
Seth

