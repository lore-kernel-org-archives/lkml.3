Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3LLMiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:38:17 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:56151 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3LLMiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:38:15 -0500
Date: Thu, 12 Dec 2013 13:38:07 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: Resume regression on MBA2,1 triggered by
 2167e2399dc5e69c62db56d933e9c8cbe107620a
Message-ID: <20131212133807.1c68707b@neptune.home>
In-Reply-To: <20131211012529.GA6354@kroah.com>
References: <20131211010852.09ddf512@neptune.home>
	<20131211012529.GA6354@kroah.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, 10 December 2013 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Wed, Dec 11, 2013 at 01:08:52AM +0100, Bruno Prémont wrote:
> > I have bisected failing resume from S3 on my MBA2,1 to be caused by
> > the following patch (introduced between 3.13-rc2 and 3.13-rc3 - rc2
> > resuming as expected, rc3 failing to resume).
> > 
> > Unfortunately I have no trace for the failing resume though CPU seems
> > to not be busy as fan does not start blowing (even when waiting more
> > than 10 minutes for the resume to eventually proceed which it does not).
> > 
> > Kernel config and dmesg are attached (gzip compressed).
> > 
> >   commit 2167e2399dc5e69c62db56d933e9c8cbe107620a
> >   Author: Bjørn Mork <bjorn@mork.no>
> >   Date:   Tue Dec 3 12:14:32 2013 +0100
> >   Subject: cpufreq: fix garbage kobjects on errors during suspend/resume
> 
> This has already been reverted in Linus's tree, see commit
> d4faadd5d5b368a7051fef374ee933ec3606713b for the details.
> 
> Does Linus's tree still have the same problem for you?

The revert in Linus's tree does fix the resume problem,
(tested commit: 9538e10086bd1301fe, merge of linux-watchdog).

thanks,
Bruno

> thanks,
> 
> greg k-h
