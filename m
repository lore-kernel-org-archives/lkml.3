Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3FZNMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:12:08 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34843 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab3FZNMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:12:05 -0400
Date: Wed, 26 Jun 2013 14:12:00 +0100
From: "matt@console-pimps.org" <matt@console-pimps.org>
To: Zachary Bobroff <zacharyb@ami.com>
Cc: "'H. Peter Anvin'" <hpa@zytor.com>, "'Jan Beulich'" <jbeulich@suse.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>, Joey Lee <JLee@suse.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Message-ID: <20130626131200.GN22026@console-pimps.org>
References: <51BEF71402000078000DEC12@nat28.tlf.novell.com>
 <20130617101745.GB8569@console-pimps.org>
 <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
 <20130617123052.GE8569@console-pimps.org>
 <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com>
 <51C068C1020000780009C995@nat28.tlf.novell.com>
 <7BD74F8E52BFD147B6C83AE7A1E893FFE286040C@atlms1.us.megatrends.com>
 <20130619084329.GA5386@console-pimps.org>
 <298f16e6-7ada-4f2e-8dae-f3919e7c8225@email.android.com>
 <7BD74F8E52BFD147B6C83AE7A1E893FFE28622FD@atlms1.us.megatrends.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7BD74F8E52BFD147B6C83AE7A1E893FFE28622FD@atlms1.us.megatrends.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun, at 06:04:50PM, Zachary Bobroff wrote:
> All,
> 
> I am attaching a further updated version of eboot.c .  We removed the
> low_alloc routine from the exit_boot function only.  We also removed
> the goto statements(sorry we just aren’t huge fans of goto's in c, you
> can change it back to be goto oriented if you want though) and put it
> in a loop that is counting down from retry count.  You can see the
> loop is based upon this conditional:

It would be much easier to review these changes if you sent them as a
patch against a git tree, using git to generate the patch. Failing that,
even a plain old diff-format file would be acceptable.

> while((ExitRetryCount > 0) && (status != EFI_SUCCESS)) {
> 
> So we have currently set ExitRetryCount to 2 (a couple of lines above):
> int ExitRetryCount = 2;
> 
> However, I have a suggestion and im not entirely sure how difficult it
> would be, im just suggesting it might not be a bad idea.  We can
> initialize this ExitRetryCount to be some default value, but if
> grub(or a different bootloader) passes some updated value,
> ExitRetryCount could be updated with this value.  Myself, I don’t know
> the level of complexity it creates pulling a kernel parameter, but
> given a decent example, I could see about adding that support.
> Allowing passing of a parameter could eliminate problems with the
> systems that may be out of specification.
 
We try to pull workarounds for these problems into the kernel, rather
than relying on bootloaders to pass in the necessary flags. People
rarely want to update their boot loaders, but most distributions release
updates for installed kernels semi-regularly.

-- 
Matt Fleming, Intel Open Source Technology Center
