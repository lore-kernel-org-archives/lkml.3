Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab3JODPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226Ab3JODPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:15:20 -0400
Message-ID: <525CB33A.4080103@redhat.com>
Date: Tue, 15 Oct 2013 11:15:06 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH net 2/2] virtio-net: refill only when device is up during
 setting queues
References: <1381744595-26881-1-git-send-email-jasowang@redhat.com> <1381744595-26881-2-git-send-email-jasowang@redhat.com> <20131014110951.GG30954@redhat.com>
In-Reply-To: <20131014110951.GG30954@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 07:09 PM, Michael S. Tsirkin wrote:
> On Mon, Oct 14, 2013 at 05:56:35PM +0800, Jason Wang wrote:
>> > We used to schedule the refill work unconditionally after changing the
>> > number of queues. This may lead an issue if the device is not
>> > up. Since we only try to cancel the work in ndo_stop(), this may cause
>> > the refill work still work after removing the device. Fix this by only
>> > schedule the work when device is up.
>> > 
>> > The bug were introduce by commit 9b9cd8024a2882e896c65222aa421d461354e3f2.
>> > (virtio-net: fix the race between channels setting and refill)
>> > 
>> > Cc: Rusty Russell <rusty@rustcorp.com.au>
>> > Cc: Michael S. Tsirkin <mst@redhat.com>
>> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> It bothers me that we look at the flag without any
> locks here.
> I think we'll need to take the rtnl lock at least
> on restore.
>

True, will post v2.
