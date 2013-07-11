Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab3GKO5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:57:16 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:50116 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab3GKO5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:57:14 -0400
X-IronPort-AV: E=Sophos;i="4.87,1043,1363132800"; 
   d="scan'208";a="6589122"
Message-ID: <51DEC7C8.1090509@citrix.com>
Date: Thu, 11 Jul 2013 16:57:12 +0200
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 3/4] xen-blkfront: prevent hoarding all
 grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <1373288607-1876-4-git-send-email-roger.pau@citrix.com> <51DEB3D5.2050101@citrix.com>
In-Reply-To: <51DEB3D5.2050101@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/13 15:32, David Vrabel wrote:
> On 08/07/13 14:03, Roger Pau Monne wrote:
>> Prevent blkfront from hoarding all grants by adding a minimum number
>> of grants that must be free at all times. We still need a way to free
>> unused grants in blkfront, but this patch will mitigate the problem
>> in the meantime.
> 
> I think this could end up with the a frontend being able to get no
> grants because some other frontend always grabs the free grants first.
> 
> Particularly as the free grant callbacks are done in the wrong order.

I'm not so sure this patch is worth pushing any more, given that we will
be freeing grants instead of keeping them all in blkfront.

It seems like it might still be useful if we are under a lot of IO
pressure on different blkfronts and for example wanted to hot-attach a
new network interface (which requires 512 grants).
