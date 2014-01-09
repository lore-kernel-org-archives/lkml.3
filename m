Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbaAIMK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:10:26 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:35373 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaAIMKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:10:05 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 07:10:05 EST
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/UwZ1qHk8=
X-RZG-CLASS-ID: mo00
Date: Thu, 9 Jan 2014 13:03:51 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140109120351.GA25423@aepfle.de>
References: <1389224915-8737-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389224915-8737-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, K. Y. Srinivasan wrote:

> +++ b/tools/hv/hv_fcopy_daemon.c

> +		len = pread(fcopy_fd, buffer, (4096 * 2), 0);
> +
> +		if (len <= 0) {
> +			syslog(LOG_ERR, "Read error: %s\n", strerror(errno));
> +			continue;

This could flood syslog. I think the error should be logged just once.
Maybe like this:

        if (len <=0) {
                if (!error) {
                        syslog(...);
                        error = HV_ERROR_NOT_SUPPORTED;
                }
                continue;
        }

> +		}
> +		in_msg = (struct hv_fcopy_hdr *)buffer;
> +
> +		switch (in_msg->operation) {
> +		case START_FILE_COPY:
> +			error = hv_start_fcopy((struct hv_start_fcopy *)in_msg);

Olaf
