Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaAUTNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:13:31 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:42606 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaAUTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:13:30 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstAo5SQMel8AXawDOUvwr8pxjMon91SD6m7JJcBA==
X-RZG-CLASS-ID: mo00
Date: Tue, 21 Jan 2014 20:13:26 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V3 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140121191326.GA16171@aepfle.de>
References: <1390331164-14292-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390331164-14292-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, K. Y. Srinivasan wrote:

Looks better. A few comments below:


> +++ b/drivers/hv/hv_fcopy.c

> +static bool daemon_died;

This is a write only variable.

> +static u32 daemon_version;

This is a write only variable.

> +static int fcopy_handle_handshake(u32 version)
> +{
> +	pr_info("FCP: user-mode registering done. Daemon version: %d\n",
> +		version);
> +	fcopy_transaction.active = false;
> +	daemon_version = version;

I think fcopy_handle_handshake should proactivly reject requests if
version is not 0.

There is an unused FCOPY_VERSION as well. I think this should not be in
a header. Instead the kernel should handle all known versions and reject
everything it does not know about.

> +	syslog(LOG_INFO, "Target file name: %s\n", target_fname);

Newline in syslog

> +				if (mkdir((char *)smsg->path_name, 0755)) {
> +					syslog(LOG_ERR, "Failed to create %s\n",

Newline in syslog

> +		syslog(LOG_INFO, "File: %s exists\n", target_fname);

Newline in syslog

> +		syslog(LOG_INFO, "Open Failed: %s\n", strerror(errno));

Newline in syslog

> +				syslog(LOG_ERR, "Read error: %s\n",

Newline in syslog

> +			syslog(LOG_ERR, "Unknown operation: %d\n",

Newline in syslog

Olaf
