Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3LKBYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:24:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LKBYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:24:00 -0500
Date: Tue, 10 Dec 2013 17:25:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: Resume regression on MBA2,1 triggered by
 2167e2399dc5e69c62db56d933e9c8cbe107620a
Message-ID: <20131211012529.GA6354@kroah.com>
References: <20131211010852.09ddf512@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131211010852.09ddf512@neptune.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 01:08:52AM +0100, Bruno Prémont wrote:
> Hi Bjørn, Rafael,
> 
> I have bisected failing resume from S3 on my MBA2,1 to be caused by
> the following patch (introduced between 3.13-rc2 and 3.13-rc3 - rc2
> resuming as expected, rc3 failing to resume).
> 
> Unfortunately I have no trace for the failing resume though CPU seems
> to not be busy as fan does not start blowing (even when waiting more
> than 10 minutes for the resume to eventually proceed which it does not).
> 
> Kernel config and dmesg are attached (gzip compressed).
> 
>   commit 2167e2399dc5e69c62db56d933e9c8cbe107620a
>   Author: Bjørn Mork <bjorn@mork.no>
>   Date:   Tue Dec 3 12:14:32 2013 +0100
>   Subject: cpufreq: fix garbage kobjects on errors during suspend/resume

This has already been reverted in Linus's tree, see commit
d4faadd5d5b368a7051fef374ee933ec3606713b for the details.

Does Linus's tree still have the same problem for you?

thanks,

greg k-h
