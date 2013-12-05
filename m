Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3LEPzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:55:12 -0500
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:47308 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751545Ab3LEPzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:55:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2375:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: range86_83c260790e755
X-Filterd-Recvd-Size: 2788
Message-ID: <1386258903.10003.8.camel@joe-AO722>
Subject: Re: [PATCH 1/3] Introduce FW_INFO* functions and messages
From: Joe Perches <joe@perches.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 05 Dec 2013 07:55:03 -0800
In-Reply-To: <20131205113016.GB3823@console-pimps.org>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>
	 <1385997579-22240-2-git-send-email-prarit@redhat.com>
	 <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
	 <201312041922.59181.arnd@arndb.de>
	 <20131205113016.GB3823@console-pimps.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 11:30 +0000, Matt Fleming wrote:
> On Wed, 04 Dec, at 07:22:57PM, Arnd Bergmann wrote:
> > The other part I noticed about this particular patchset is that it's
> > not really "firmware" as such, but specifically PC wiht ACPI that
> > gets covered here. So rather than generalizing the code, another
> > option would be to narrow down the scope and make it
> > acpi_{warn,info,dbg} instead.
> 
> Making this specific to ACPI runs the risk of people introducing a
> multitude of new logging functions for every subsystem, e.g.
> efi_{warn,info,dbg}.

There are many subsystem specific logging functions:

$ grep -rP --include=*.[ch] -oh "\b[a-z_]+_warn\b\s*\(" *| \
  sed -r 's/\s*//g'|sort|uniq -c|sort -rn|head -25
   3808 dev_warn(
   1964 pr_warn(
    468 netdev_warn(
    194 xfs_warn(
    120 xhci_warn(
    102 ipoib_warn(
     76 netif_warn(
     64 tuner_warn(
     53 hid_warn(
     51 ata_dev_warn(
     46 mthca_warn(
     45 nv_warn(
     41 ubi_warn(
     32 wiphy_warn(
     32 osm_warn(
     31 rbd_warn(
     28 ubifs_warn(
     27 psmouse_warn(
     27 e_warn(
     25 blogic_warn(
     23 en_warn(
     23 ata_link_warn(
     22 jfs_warn(
     21 csio_warn(
     21 cam_warn(

> FWIW, I'd be interested in using something like this patch series to
> properly log EFI implementation bugs. The logging for EFI is currently
> done fairly haphazardly.

I thought that was the point of embedding the existing
FW_INFO, FW_WARN and FW_BUG #defines in formats.

Using logging message scraping to find faults is not
a great approach as message content is subject to change.


