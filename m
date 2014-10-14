Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaJNSsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 14:48:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56307 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754166AbaJNSsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 14:48:41 -0400
Date: Tue, 14 Oct 2014 15:47:02 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
Message-ID: <20141014184702.GA12662@arch.hh.imgtec.org>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
 <20141014143902.GA9768@arch.hh.imgtec.org>
 <1413299343.7906.103.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413299343.7906.103.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Oct 06:09 PM, Artem Bityutskiy wrote:
> On Tue, 2014-10-14 at 11:39 -0300, Ezequiel Garcia wrote:
> > Please use some pr_fmt for this. Something like this before the headers
> > should be enough:
> > 
> > #define pr_fmt(fmt) "UBI: block:" fmt
> 
> Sinc ubiblock is a device, there should be a 'struct device' somewhere,
> so probably dev_printk() and other dev_*() printing functions would be a
> better choice?
> 

A quick code dig shows you should get the struct device associated
to the struct gendisk, with the disk_to_dev() macro.

In other words, something like this should work, provided 'dev' is defined
in the scope as a struct ubiblock:

  #define ubiblock_err(x) dev_err(disk_to_dev(dev->gd), x)

When the gendisk is not available, a simple pr_{} would work.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
