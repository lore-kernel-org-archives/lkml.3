Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab3CGOE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:04:57 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:54457 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3CGOE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:04:56 -0500
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Schroeder <mls@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
In-Reply-To: <1362664663.15011.194.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362652440.28562.26.camel@linux-s257.site>
	 <1362656348.15011.166.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362664663.15011.194.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Mar 2013 22:03:33 +0800
Message-ID: <1362665013.28562.48.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt, 

於 四，2013-03-07 於 13:57 +0000，Matt Fleming 提到：
> On Thu, 2013-03-07 at 11:39 +0000, Matt Fleming wrote:
> > On Thu, 2013-03-07 at 18:34 +0800, joeyli wrote:
> > > The VariableNameSize is not reliable when EFI_SUCCESS is returned
> > > because UEFI 2.3.1 spec only mention VariableNameSize should updated
> > > when EFI_BUFFER_TOO_SMALL is returned. And, the 1024 bytes of buffer is
> > > from old UEFI spec. There doesn't have any size condition of variable
> > > data or variable name in 2.3.1 spec.
> > 
> > The spec may only mention what happens in the EFI_BUFFER_TOO_SMALL case,
> > but for EFI_SUCCESS, any behaviour other than leaving VariableNameSize
> > alone or updating it with the required size of the buffer is just
> > completely insane.
> > 
> > > I modified the patch to grab VariableNameSize when EFI_BUFFER_TOO_SMALL,
> > > the behavior like what we do in efivarfs_file_read().
> > 
> > Thanks, this does seem like the most robust solution.
> 
> Also, you're probably going to need to update
> efivar_update_sysfs_entries() too.
> 

Thanks for your review! I will send out v2 patch after modify and test
on issue machine.


Thanks a lot!
Joey Lee

