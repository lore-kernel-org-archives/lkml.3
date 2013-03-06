Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3CFJUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:20:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab3CFJUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:20:39 -0500
Message-ID: <51370A51.1050505@redhat.com>
Date: Wed, 06 Mar 2013 17:20:17 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Schroeder <mls@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
References: <1362108018-13117-1-git-send-email-jlee@suse.com>  <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>  <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>  <1362181299.23932.168.camel@linux-s257.site> <1362555258.23932.573.camel@linux-s257.site>
In-Reply-To: <1362555258.23932.573.camel@linux-s257.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 03:34 PM, joeyli wrote:
> +static unsigned long variable_name_length(efi_char16_t *variable_name)
> +{
> +	unsigned long len;
> +	efi_char16_t c;
> +
> +	len = 2;
> +	do {
> +		c = variable_name[len / sizeof(c) - 1];
> +		if (c)
> +			len += sizeof(c);
> +	} while (c);
> +
> +	return len;
> +}
> +

It looks like this function can be replaced with utf16_strsize.
