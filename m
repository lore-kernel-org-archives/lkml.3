Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3BKFlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 00:41:12 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:65173 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3BKFlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 00:41:10 -0500
Date: Sun, 10 Feb 2013 21:41:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 2/2] zram: gather statistics in a unique file
Message-ID: <20130211054117.GA31340@kroah.com>
References: <1360556946.4204.5.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360556946.4204.5.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 08:29:06PM -0800, Davidlohr Bueso wrote:
> Instead of having one sysfs file per zram statistic, group them all
> in a single, reader-friendly, 'statistics' file. This not only reduces
> code but is also makes it easier to visualize. The new file looks like:
> 
> Number of reads:        24
> Number of writes:       1055
> Invalid IO:             0
> Notify free:            0
> Zero pages:             1042
> Orig data size:         49152 bytes
> Compressed data:        838 bytes
> Total memory used:      53248 bytes
> 
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

No, please, the rule for sysfs is "one value per file", not files with
lots of data that you need to parse.

If you want to do something like this, then do it in debugfs, but NEVER
in sysfs.

sorry,

greg k-h
