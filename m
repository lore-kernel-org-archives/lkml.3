Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3CFHlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:41:13 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:51273 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3CFHlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:41:12 -0500
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Schroeder <mls@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
In-Reply-To: <1362555258.23932.573.camel@linux-s257.site>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Mar 2013 15:39:49 +0800
Message-ID: <1362555589.23932.582.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-03-06 於 15:34 +0800，joeyli 提到：
> Hi Matt, 
> 
> 於 六，2013-03-02 於 07:41 +0800，joeyli 提到：
> > 於 五，2013-03-01 於 16:31 +0000，Matt Fleming 提到：
> > > On Fri, 2013-03-01 at 15:17 +0000, Matt Fleming wrote:
> > > > On Fri, 2013-03-01 at 11:20 +0800, Lee, Chun-Yi wrote:
> > > > > From: Michael Schroeder <mls@suse.com>
> > > > > 
> > > > > On HP z220 system (firmware version 1.54), some EFI variables
> are incorrectly
> > > > > named :
> > > > > 
> > > > > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> > > >
> > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > >
> > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > >
> > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > >
> > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > > > 
> > > > > That causes by the following statement in
> efivar_create_sysfs_entry function:
> > > > > 
> > > > >  *(short_name + strlen(short_name)) = '-';
> > > > > efi_guid_unparse(vendor_guid, short_name +
> strlen(short_name));
> > > > > 
> > > > > The trailing \0 is overwritten with '-', but the next char
> doesn't seem to be a \0
> > > > > as well for HP. So, the second strlen return the point of next
> '\0', causes there
> > > > > have garbage string attached before GUID.
> > > > > 
> > > > > Tested on On HP z220.
> > > > 
> > > > What's more likely happening here is that GetNextVariable() is
> broken on
> > > > this HP firmware and variable_name_size is too big for the given
> > > > variable in variable_name. We've seen other reports of similar
> bugs,
> > > > 
> > > >   https://bugzilla.kernel.org/show_bug.cgi?id=47631
> > > > 
> > > > 
> > > > Could someone try this patch against Linus' tree?
> > > 
> > > Urgh, and here's a version that isn't utterly, utterly broken...
> > 
> > Thanks for Matt's patch, we will try it!
> > 
> > Joey Lee
> 
> Frederic confirmed your patch works to him for fix issue on HP
> machine.
> 
> Tested-by: Frederic Crozat <fcrozat@suse.com>

Sorry forgot paste variable_name_size from log:

efivars: bogus variable_name_size: 34 1024
efivars: bogus variable_name_size: 22 1024

The GetNextVariable() always return variable_name_size is 1024.


Thanks a lot!
Joey Lee

