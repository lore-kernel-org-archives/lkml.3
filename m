Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaBMFlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:41:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaBMFlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:41:10 -0500
Message-ID: <52FC5AEB.3090503@redhat.com>
Date: Thu, 13 Feb 2014 13:40:59 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>
Subject: Re: [PATCH net] virtio-net: alloc big buffers also when guest can
 receive UFO
References: <1392183808-16789-1-git-send-email-jasowang@redhat.com> <20140212115901.GC23006@redhat.com> <52FC35B5.6000900@redhat.com> <20140213051559.GB31352@redhat.com>
In-Reply-To: <20140213051559.GB31352@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 01:15 PM, Michael S. Tsirkin wrote:
> On Thu, Feb 13, 2014 at 11:02:13AM +0800, Jason Wang wrote:
>> On 02/12/2014 07:59 PM, Michael S. Tsirkin wrote:
>>> On Wed, Feb 12, 2014 at 01:43:28PM +0800, Jason Wang wrote:
>>>>> We should alloc big buffers also when guest can receive UFO
>>>>> pakcets. Otherwise the big packets will be truncated when mergeable rx
>>>>> buffer is disabled.
>>> Not truncated, they will be dropped.
>>>
>> Why dropped? We enable the ufo on tap0 if VIRTIO_NET_F_GUEST_UFO is
>> negotiated. So skb was queued on the receive queue. But since the
>> receive buffer is small, it will be truncated during tun_put_user().
> Hypervisor shouldn't truncate packets silently - if it does
> it's a hypervisor bug. Passing malformed packets to guest is
> a bad idea.
>

Yes, but the commit log describes the current behaviour so it was ok?

Btw, dropping the packets silently is still not good. Virito needs a
method to report rx errors to guest.
