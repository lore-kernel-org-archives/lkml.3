Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750953AbaLPJeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:34:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaLPJeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:34:22 -0500
Message-ID: <1418722450.2448.3.camel@linux-0dmf.site>
Subject: Re: [PATCH 4/4 v4] scsi:stex.c Add S3/S4 support
From: Oliver Neukum <oneukum@suse.de>
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com,
        ed.lin@promise.com, grace.chang@tw.promise.com,
        linus.chen@tw.promise.com, victor.p@promise.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2014 10:34:10 +0100
In-Reply-To: <548FCDC8.1010900@gmail.com>
References: <548FCDC8.1010900@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 14:14 +0800, Charles Chiou wrote:
>  From f9d84df080c16097218092630db9b5df31d487b5 Mon Sep 17 00:00:00 2001
> From: Charles Chiou <charles.chiou@tw.promise.com>
> Date: Fri, 7 Nov 2014 10:15:18 +0800
> Subject: [PATCH 4/4] scsi:stex.c Add S3/S4 support
> 
> Add S3/S4 support, add .suspend and .resume function in pci_driver.
> 
> Pegasus need 30~40 seconds to boot up. We don't want to OS wait
> in .resume function. Create a thread to handle device boot up.

I am sorry to be obnoxious, but this patch raises another
question. What happens if the the system is suspended again
while the work scheduled in resume is still running?

Furthermore, what happens in the case of a PCI hotunplug while
the work is still scheduled?

	Regards
		Oliver


