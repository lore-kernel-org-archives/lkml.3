Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaANWN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:13:29 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:59170 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaANWN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:13:26 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssVYxSFJSlSFHc//WORzCfkz/AXknJsPmneTL2bA==
X-RZG-CLASS-ID: mo00
Date: Tue, 14 Jan 2014 23:13:23 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140114221323.GA16960@aepfle.de>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389728116-21337-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, K. Y. Srinivasan wrote:


> +static ssize_t fcopy_write(struct file *file, const char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	int error = 0;
> +
> +	if (count != sizeof(int))
> +		return 0;
> +
> +	if (copy_from_user(&error, buf, sizeof(int)))
> +		return -EFAULT;
> +
> +	if (in_hand_shake) {
> +		fcopy_handle_handshake();
> +		return 0;
> +	}


> +	/*
> +	 * Register with the kernel.
> +	 */
> +	write(fcopy_fd, &version, sizeof(int));


Shouldnt there be some version check already even in this initial
implementation? What if there will be a newer daemon running on an older
kernel?

Olaf
