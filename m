Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaAPL0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:26:42 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:11355 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAPL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:26:40 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssVY9SQsClBrtp5eFYXU7YfNKMAfocpEeot7SjdQ==
X-RZG-CLASS-ID: mo00
Date: Thu, 16 Jan 2014 12:26:33 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140116112633.GA28584@aepfle.de>
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

This function should return valid numbers:

> +static ssize_t fcopy_write(struct file *file, const char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	int error = 0;
> +
> +	if (count != sizeof(int))
> +		return 0;

Should be an error.

> +
> +	if (copy_from_user(&error, buf, sizeof(int)))
> +		return -EFAULT;
> +
> +	if (in_hand_shake) {
> +		fcopy_handle_handshake();
> +		return 0;

Should be sizeof(int).

> +	}
> +
> +	/*
> +	 * Complete the transaction by forwarding the result
> +	 * to the host. But first, cancel the timeout.
> +	 */
> +	if (cancel_delayed_work_sync(&fcopy_work))
> +		fcopy_respond_to_host(error);
> +
> +	return sizeof(int);
> +}

