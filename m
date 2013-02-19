Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3BSIps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:45:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab3BSIpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:45:46 -0500
Message-ID: <51233BB2.3080401@redhat.com>
Date: Tue, 19 Feb 2013 09:45:38 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andy King <acking@vmware.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com> <511CC511.7080902@redhat.com> <1398469748.2079082.1361207251021.JavaMail.root@vmware.com>
In-Reply-To: <1398469748.2079082.1361207251021.JavaMail.root@vmware.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/13 18:07, Andy King wrote:
> Hi Gerd,
> 
>>> +		written = transport->stream_enqueue(
>>> +				vsk, msg->msg_iov,
>>> +				len - total_written);
>>
>> Hmm, shouldn't we pass total_written to stream_enqueue here?
>>
>> In case a blocking send(big-buffer) call gets splitted into multiple
>> stream_enqueue calls the second (and further) stream_enqueue calls need
>> to know at which msg offset they should continue sending the data, no?
> 
> On the client side, the iov tracks it internally; see memcpy_fromiovec().

Ah, memcpy_fromiovec patches the iovec to keep track of the offset.
Wasn't aware it does this.  Yes, we don't need to pass the offset then.

cheers,
  Gerd

