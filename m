Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3GJOvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:51:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56099 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752792Ab3GJOva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:51:30 -0400
Message-ID: <1373467888.14604.32.camel@joe-AO722>
Subject: Re: [PATCH] firmware/dmi_scan: Drop OOM messages
From: Joe Perches <joe@perches.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 10 Jul 2013 07:51:28 -0700
In-Reply-To: <1373460424.4399.45.camel@chaos.site>
References: <1373460424.4399.45.camel@chaos.site>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

even more trivial...

On Wed, 2013-07-10 at 14:47 +0200, Jean Delvare wrote:
> +++ linux-3.11-rc0/drivers/firmware/dmi_scan.c	2013-07-10 14:11:56.544792703 +0200
> @@ -62,8 +62,6 @@ static const char * __init dmi_string(co
>  	str = dmi_alloc(len);
>  	if (str != NULL)
[]
> @@ -219,10 +217,8 @@ static void __init dmi_save_one_device(i
>  	dev = dmi_alloc(sizeof(*dev) + strlen(name) + 1);
> +	if (!dev)
>  		return;
[]
> @@ -258,10 +254,8 @@ static void __init dmi_save_oem_strings_
>  		dev = dmi_alloc(sizeof(*dev));
> +		if (!dev)
>  			break;
[]
> @@ -277,18 +271,14 @@ static void __init dmi_save_ipmi_device(
>  	data = dmi_alloc(dm->length);
> +	if (data == NULL)
>  		return;
[]
>  	dev = dmi_alloc(sizeof(*dev));
> +	if (!dev)
>  		return;
[]
> @@ -303,10 +293,9 @@ static void __init dmi_save_dev_onboard(
>  	onboard_dev = dmi_alloc(sizeof(*onboard_dev) + strlen(name) + 1);
> +	if (!onboard_dev)
>  		return;

It'd also be nice to use the same test style
in all 6 uses.

	if (!foo)


