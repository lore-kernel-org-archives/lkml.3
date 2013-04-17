Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936238Ab3DQR2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:28:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16785 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934393Ab3DQR17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:27:59 -0400
Date: Wed, 17 Apr 2013 13:27:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        martin.peterson@oracle.com, axboe@kernel.dk
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v1 7/7] xen-block: implement indirect descriptors
Message-ID: <20130417172747.GA25736@phenom.dumpdata.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
 <1364382643-3711-8-git-send-email-roger.pau@citrix.com>
 <20130409184923.GA4978@phenom.dumpdata.com>
 <516C3264.3050409@citrix.com>
 <20130417142554.GG21378@phenom.dumpdata.com>
 <516ED633.3040205@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <516ED633.3040205@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 07:04:51PM +0200, Roger Pau Monné wrote:
> On 17/04/13 16:25, Konrad Rzeszutek Wilk wrote:
> >>> Perhaps the xen-blkfront part of the patch should be just split out to make
> >>> this easier?
> >>>
> >>> Perhaps what we really should have is just the 'max' value of megabytes
> >>> we want to handle on the ring.
> >>>
> >>> As right now 32 ring requests * 32 segments = 4MB.  But if the user wants
> >>> to se the max: 32 * 4096 = so 512MB (right? each request would handle now 16MB
> >>> and since we have 32 of them = 512MB).
> >>
> >> I've just set that to something that brings a performance benefit
> >> without having to map an insane number of persistent grants in blkback.
> >>
> >> Yes, the values are correct, but the device request queue (rq) is only
> >> able to provide read requests with 64 segments or write requests with
> >> 128 segments. I haven't been able to get larger requests, even when
> >> setting this to 512 or higer.
> > 
> > What are you using to drive the requests? 'fio'?
> 
> Yes, I've tried fio with several "bs=" values, but it doesn't seem to
> change the size of the underlying requests. Have you been able to get
> bigger requests?

Martin, Jens,
Any way to drive more than 128 segments?
