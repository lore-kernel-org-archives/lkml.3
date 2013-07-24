Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab3GXEmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:42:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab3GXEmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:42:07 -0400
Message-ID: <51EF5B00.7040109@redhat.com>
Date: Wed, 24 Jul 2013 12:41:36 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>
CC: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Basil Gor <basil.gor@gmail.com>
Subject: Re: [PATCH net-next] tuntap: hardware vlan tx support
References: <1374563748-38821-1-git-send-email-jasowang@redhat.com> <20130723081727.69766d27@nehalam.linuxnetplumber.net>
In-Reply-To: <20130723081727.69766d27@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 11:17 PM, Stephen Hemminger wrote:
> On Tue, 23 Jul 2013 15:15:48 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> Inspired by commit f09e2249c4f5c7c13261ec73f5a7807076af0c8e (macvtap: restore
>> vlan header on user read). This patch adds hardware vlan tx support for
>> tuntap. This is done by copying vlan header directly into userspace in
>> tun_put_user() instead of doing it through __vlan_put_tag() in
>> dev_hard_start_xmit(). This eliminates one unnecessary memove in
>> vlan_insert_tag() for 802.1ad and 802.1q traffic.
>>
>> pktgen test shows about 20% improvement for 802.1q traffic:
>>
>> Before:
>>   662149pps 317Mb/sec (317831520bps) errors: 0
>> After:
>>   801033pps 384Mb/sec (384495840bps) errors: 0
>>
>> Cc: Basil Gor <basil.gor@gmail.com>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> You need to make this configurable by some mechanism, since otherwise
> it will break applications that expect current VLAN behavior
> --
>

Didn't see any breakage. Vlan id will always exist in the userspace buffer.
