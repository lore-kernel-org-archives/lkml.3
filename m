Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaITKAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 06:00:36 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34108 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaITKAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 06:00:34 -0400
Message-ID: <541D503B.3070507@redhat.com>
Date: Sat, 20 Sep 2014 12:00:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 2/2] vhost: support urgent descriptors
References: <1404203661-7521-1-git-send-email-mst@redhat.com>	<1404203661-7521-2-git-send-email-mst@redhat.com> <541BD6E9.2010707@redhat.com>
In-Reply-To: <541BD6E9.2010707@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/09/2014 09:10, Jason Wang ha scritto:
>> >  
>> > -	if (!vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
>> > +	if (vq->urgent || !vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
> So the urgent descriptor only work when event index was not enabled?
> This seems suboptimal, we may still want to benefit from event index
> even if urgent descriptor is used. Looks like we need return true here
> when vq->urgent is true?

Its ||, not &&.

Without event index, all descriptors are treated as urgent.

Paolo

