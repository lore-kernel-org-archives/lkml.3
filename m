Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3JVSfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:35:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:17334 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab3JVSf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:35:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="378443718"
Date: Tue, 22 Oct 2013 11:32:46 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/misc: add rawio framework driver
Message-ID: <20131022183246.GB53231@bingao-desk1.fm.intel.com>
References: <5265C0C8.10609@linux.intel.com>
 <20131022054538.GB14163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022054538.GB14163@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 06:45:38AM +0100, Greg Kroah-Hartman wrote:
> 
> Oh, one more technical thing, you totally fail to document the
> user/kernel api you have just created.

Yes, this is required to be done. Will fix it.

> You are parsing userspace data in ways that I really don't understand at all...

I don't know which specific codes you were talking about.
Overall the driver needs to parse each argument from the user command.
For example: "r iomem 0xff00c020 40", the driver needs parsing out:
r 		- read (and default width 4 bytes)
iomem		- I/O memory
0xff00c020	- the start address to read
40		- length to read	

