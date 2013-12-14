Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3LNTZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:25:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNTY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:24:59 -0500
Date: Sat, 14 Dec 2013 08:52:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH 001/115] gpu: ion: Add ION Memory Manager
Message-ID: <20131214165257.GA25393@kroah.com>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386973529-4884-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386973529-4884-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 02:23:35PM -0800, John Stultz wrote:
> +	idev->debug_root = debugfs_create_dir("ion", NULL);
> +	if (IS_ERR_OR_NULL(idev->debug_root))
> +		pr_err("ion: failed to create debug files.\n");

There's no need to check for this at all, you just printed out an error
message if CONFIG_DEBUGFS is not enabled, which isn't all that nice.

Something to clean up later, no big deal now.

thanks,

greg k-h
