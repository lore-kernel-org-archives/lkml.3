Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3GIP6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:58:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44843 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751999Ab3GIP6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:58:17 -0400
Message-ID: <1373385495.14604.4.camel@joe-AO722>
Subject: Re: [PATCH 3/3] firmware/dmi_scan: Constify strings
From: Joe Perches <joe@perches.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 09 Jul 2013 08:58:15 -0700
In-Reply-To: <1373384634.4391.10.camel@chaos.site>
References: <1373384438.4391.6.camel@chaos.site>
	 <1373384634.4391.10.camel@chaos.site>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 17:43 +0200, Jean Delvare wrote:
> Add const to all DMI string pointers where this is possible. This
> fixes a checkpatch warning.

That's a nice little improvement.

> +++ linux-3.10-rc0/drivers/firmware/dmi_scan.c	2013-05-04 11:20:52.808187924 +0200
[]
> @@ -252,7 +252,7 @@ static void __init dmi_save_oem_strings_
>  	struct dmi_device *dev;
>  
>  	for (i = 1; i <= count; i++) {
> -		char *devname = dmi_string(dm, i);
> +		const char *devname = dmi_string(dm, i);
>  
>  		if (devname == dmi_empty_string)

btw: that last test sure looks like it would be
     better written as
		if (strcmp(devname, dmi_empty_string) == 0)


