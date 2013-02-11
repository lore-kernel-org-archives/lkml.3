Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab3BKSHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:07:47 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:48361 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601Ab3BKSHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:07:45 -0500
Message-ID: <1360606065.4204.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 2/2] zram: gather statistics in a unique file
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Date: Mon, 11 Feb 2013 10:07:45 -0800
In-Reply-To: <20130211054117.GA31340@kroah.com>
References: <1360556946.4204.5.camel@buesod1.americas.hpqcorp.net>
	 <20130211054117.GA31340@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-10 at 21:41 -0800, Greg Kroah-Hartman wrote:
> On Sun, Feb 10, 2013 at 08:29:06PM -0800, Davidlohr Bueso wrote:
> > Instead of having one sysfs file per zram statistic, group them all
> > in a single, reader-friendly, 'statistics' file. This not only reduces
> > code but is also makes it easier to visualize. The new file looks like:
> > 
> > Number of reads:        24
> > Number of writes:       1055
> > Invalid IO:             0
> > Notify free:            0
> > Zero pages:             1042
> > Orig data size:         49152 bytes
> > Compressed data:        838 bytes
> > Total memory used:      53248 bytes
> > 
> > Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> 
> No, please, the rule for sysfs is "one value per file", not files with
> lots of data that you need to parse.

Ok.

> 
> If you want to do something like this, then do it in debugfs, but NEVER
> in sysfs.

So, you would you be open to having the statistics file in debugfs and
removing the individual files sysfs?

Thanks,
Davidlohr

