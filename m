Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab3CFLVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:21:37 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:43737 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757389Ab3CFLVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:21:30 -0500
Message-ID: <1362568887.15011.27.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: Matt Fleming <matt@console-pimps.org>
To: Lingzhu Xiang <lxiang@redhat.com>
Cc: joeyli <jlee@suse.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Schroeder <mls@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
Date: Wed, 06 Mar 2013 11:21:27 +0000
In-Reply-To: <51370A51.1050505@redhat.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	  <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	  <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	  <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site> <51370A51.1050505@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 17:20 +0800, Lingzhu Xiang wrote:
> On 03/06/2013 03:34 PM, joeyli wrote:
> > +static unsigned long variable_name_length(efi_char16_t *variable_name)
> > +{
> > +	unsigned long len;
> > +	efi_char16_t c;
> > +
> > +	len = 2;
> > +	do {
> > +		c = variable_name[len / sizeof(c) - 1];
> > +		if (c)
> > +			len += sizeof(c);
> > +	} while (c);
> > +
> > +	return len;
> > +}
> > +
> 
> It looks like this function can be replaced with utf16_strsize.

Nearly. For this particular case we also need to count the terminating
NULL.

-- 
Matt Fleming, Intel Open Source Technology Center

