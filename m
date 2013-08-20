Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab3HTCgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:36:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3HTCgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:36:22 -0400
Message-ID: <5212D61B.1010303@redhat.com>
Date: Tue, 20 Aug 2013 10:36:11 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] vhost: switch to use vhost_add_used_n()
References: <1376630190-5912-1-git-send-email-jasowang@redhat.com> <1376630190-5912-4-git-send-email-jasowang@redhat.com> <20130816095655.GB21821@redhat.com>
In-Reply-To: <20130816095655.GB21821@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 05:56 PM, Michael S. Tsirkin wrote:
> On Fri, Aug 16, 2013 at 01:16:27PM +0800, Jason Wang wrote:
>> > Let vhost_add_used() to use vhost_add_used_n() to reduce the code duplication.
>> > 
>> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> Does compiler inline it then?
> Reason I ask, last time I checked put_user inside vhost_add_used
> was much cheaper than copy_to_user inside vhost_add_used_n,
> so I wouldn't be surprised if this hurt performance.
> Did you check?
>

I run virtio_test but didn't see the difference.

Did you mean the might_fault() in __copy_to_user()? So how about switch
to use __put_user() if count is one in __vhost_add_used_n()?

