Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3CAOus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:50:48 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:38990 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3CAOuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:50:46 -0500
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: joeyli <jlee@suse.com>
To: Lingzhu Xiang <lxiang@redhat.com>
Cc: matt@console-pimps.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Schroeder <mls@suse.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
In-Reply-To: <5130757F.4090702@redhat.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <5130757F.4090702@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Mar 2013 22:49:35 +0800
Message-ID: <1362149375.23932.167.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2013-03-01 於 17:31 +0800，Lingzhu Xiang 提到：
> On 03/01/2013 11:20 AM, Lee, Chun-Yi wrote:
> > From: Michael Schroeder <mls@suse.com>
> > 
> > On HP z220 system (firmware version 1.54), some EFI variables are incorrectly
> > named :
> > 
> > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c
> > 
> > That causes by the following statement in efivar_create_sysfs_entry function:
> > 
> >   *(short_name + strlen(short_name)) = '-';
> > efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
> > 
> > The trailing \0 is overwritten with '-', but the next char doesn't seem to be a \0
> > as well for HP. So, the second strlen return the point of next '\0', causes there
> > have garbage string attached before GUID.
> > 
> > Tested on On HP z220.
> 
> So short_name has trailing garbage, or rather, variable_name_size
> is larger than variable_name actually is, wouldn't new_efivar->var.VariableName
> also gets filled with trailing garbage?
> 
> In efivar_store_raw the VariableName's trailing garbage can cause
> problem for comparison. You might want to also cover that or fix
> variable_name_size.
> 
> 
> Lingzhu Xiang
> 

Yes, it's possible! I will add patch for print more debug messages to
bug reporter for check it.


Thanks for your review!
Joey Lee


