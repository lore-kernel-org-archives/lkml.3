Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3CGIFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:05:17 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:35269 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3CGIFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:05:15 -0500
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: joeyli <jlee@suse.com>
To: Lingzhu Xiang <lxiang@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Schroeder <mls@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
In-Reply-To: <51370A51.1050505@redhat.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>  <51370A51.1050505@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Mar 2013 16:03:47 +0800
Message-ID: <1362643427.28562.16.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-03-06 於 17:20 +0800，Lingzhu Xiang 提到：
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
> 

Ah! thanks for you point out, I will use utf16_strsize.


Thanks a lot!
Joey Lee


