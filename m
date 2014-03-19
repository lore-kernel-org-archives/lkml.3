Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbaCSBKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:10:30 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:51343 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552AbaCSBK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:10:27 -0400
MIME-Version: 1.0
In-Reply-To: <5328ED25.1040900@lab.ntt.co.jp>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
 <1394680527-28970-2-git-send-email-mcgrof@do-not-panic.com>
 <5328E802.3030901@lab.ntt.co.jp> <CAB=NE6X2eZFLWBN1acf=d75T_K2YM_OK3oaXEPu-hwpUJEmwkg@mail.gmail.com>
 <5328ED25.1040900@lab.ntt.co.jp>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Mar 2014 18:10:05 -0700
X-Google-Sender-Auth: 1Hy3HB35fJ5iR7OVJAGYGyzmyuI
Message-ID: <CAB=NE6VL8LCGa5aqm8qpgwHywwvVb8gjNQFKic_Dq9zdg-8hDQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] bridge: preserve random init MAC address
To: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 6:04 PM, Toshiaki Makita
<makita.toshiaki@lab.ntt.co.jp> wrote:
> (2014/03/19 9:50), Luis R. Rodriguez wrote:
>> On Tue, Mar 18, 2014 at 5:42 PM, Toshiaki Makita
>> <makita.toshiaki@lab.ntt.co.jp> wrote:
>>> nit,
>>> If the last detached port happens to have the same addr as
>>> random_init_addr, this seems to call br_stp_change_bridge_id() even
>>> though bridge_id is not changed.
>>
>> Ah good point.
>>
>>> Shouldn't the assignment of random_init_addr be done before the check of
>>> "no change"?
>>
>> Good question, should we even allow two ports to have the same MAC
>> address or should we complain and refuse to add it? If so that should
>> mean we should also have to monitor any manual address changes or
>> events for address changes on the ports.
>
> This was recently discussed by Stephen and me.
> I'm thinking it should be allowed.
>
> http://marc.info/?l=linux-netdev&m=139182743919257&w=2

Great now that that's sorted out though I still think calling
br_stp_change_bridge_id() is right just as calling the update features
as the device is different. It could however be confusing when this
situation is run and folks might report odd bugs unless we could tell
them apart clearly. Thoughts?

  Luis
