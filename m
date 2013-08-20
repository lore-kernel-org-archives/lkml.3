Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3HTCdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:33:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3HTCdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:33:13 -0400
Message-ID: <5212D564.80200@redhat.com>
Date: Tue, 20 Aug 2013 10:33:08 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] vhost_net: use vhost_add_used_and_signal_n() in vhost_zerocopy_signal_used()
References: <1376630190-5912-1-git-send-email-jasowang@redhat.com> <1376630190-5912-3-git-send-email-jasowang@redhat.com> <20130816095426.GA21821@redhat.com>
In-Reply-To: <20130816095426.GA21821@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 05:54 PM, Michael S. Tsirkin wrote:
> On Fri, Aug 16, 2013 at 01:16:26PM +0800, Jason Wang wrote:
>> > Switch to use vhost_add_used_and_signal_n() to avoid multiple calls to
>> > vhost_add_used_and_signal(). With the patch we will call at most 2 times
>> > (consider done_idx warp around) compared to N times w/o this patch.
>> > 
>> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> So? Does this help performance then?
>

Looks like it can especially when guest does support event index. When
guest enable tx interrupt, this can saves us some unnecessary signal to
guest. I will do some test.
