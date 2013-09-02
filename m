Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3IBG2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:28:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab3IBG2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:28:43 -0400
Message-ID: <52243015.9080101@redhat.com>
Date: Mon, 02 Sep 2013 14:28:37 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/6] vhost_net: use vhost_add_used_and_signal_n() in
 vhost_zerocopy_signal_used()
References: <1377836962-49780-1-git-send-email-jasowang@redhat.com> <1377836962-49780-3-git-send-email-jasowang@redhat.com> <20130902055048.GA19838@redhat.com>
In-Reply-To: <20130902055048.GA19838@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 01:50 PM, Michael S. Tsirkin wrote:
> On Fri, Aug 30, 2013 at 12:29:18PM +0800, Jason Wang wrote:
>> > We tend to batch the used adding and signaling in vhost_zerocopy_callback()
>> > which may result more than 100 used buffers to be updated in
>> > vhost_zerocopy_signal_used() in some cases. So wwitch to use
> switch

Ok.
>> > vhost_add_used_and_signal_n() to avoid multiple calls to
>> > vhost_add_used_and_signal(). Which means much more less times of used index
>> > updating and memory barriers.
> pls put info on perf gain in commit log too
>

Sure.
