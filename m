Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaA3JxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 04:53:06 -0500
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:47078 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751097AbaA3JxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 04:53:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:2901:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:4605:5007:6119:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stick32_548a9876ebb2d
X-Filterd-Recvd-Size: 2092
Message-ID: <1391075579.2422.53.camel@joe-AO722>
Subject: Re: [PATCH v4] HID: New hid-cp2112 driver
From: Joe Perches <joe@perches.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: David Barksdale <dbarksdale@uplogix.com>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jakub =?ISO-8859-1?Q?K=E1kona?= <kjakub@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 30 Jan 2014 01:52:59 -0800
In-Reply-To: <1391067307.11310.3.camel@linux-fkkt.site>
References: <1391037975-26253-1-git-send-email-dbarksdale@uplogix.com>
	 <1391039165.2422.11.camel@joe-AO722>
	 <1391067307.11310.3.camel@linux-fkkt.site>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-30 at 08:35 +0100, Oliver Neukum wrote:
> On Wed, 2014-01-29 at 15:46 -0800, Joe Perches wrote:
> 
> > > +static int cp2112_hid_get(struct hid_device *hdev, unsigned char report_number,
> > > +			  u8 *data, size_t count, unsigned char report_type)
> > > +{
> > > +	u8 *buf;
> > > +	int ret;
> > > +
> > > +	buf = kmalloc(count, GFP_KERNEL);
> > > +	if (!buf)
> > > +		return -ENOMEM;
> > > +
> > > +	ret = hdev->hid_get_raw_report(hdev, report_number, buf, count,
> > > +				       report_type);
> > > +	memcpy(data, buf, count);
> > > +	kfree(buf);
> > > +	return ret;
> > 
> > if the data is going to be copied in data,
> > why not just use data in hid_get_raw_report
> > and avoid the malloc?
> 
> He must not. It would violate the DMA rules. This function is passed
> pointers to parts of structures. Access to the structures may race
> with a DMA to/from the buffer. That violates the DMA rules.

If this is going to be used to DMA, doesn't
the alloc need to be GFP_KERNEL | GFP_DMA ?


