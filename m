Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbbAEAea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 19:34:30 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:41959 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbAEAe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 19:34:28 -0500
MIME-Version: 1.0
In-Reply-To: <1420408540.5686.140.camel@decadent.org.uk>
References: <1420405017-23278-1-git-send-email-ddecotig@gmail.com>
	<1420408540.5686.140.camel@decadent.org.uk>
Date: Mon, 5 Jan 2015 01:34:26 +0100
Message-ID: <CAHo-Ooxi8V_58b456vePY9_7ChuBe0jxEVHvGkGvRBpAR744yA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 0/7] net: extend ethtool link mode bitmaps to
 48 bits
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Decotigny <ddecotig@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Masatake YAMATO <yamato@redhat.com>,
        Xi Wang <xii@google.com>, Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        Tom Gundersen <teg@jklm.no>, Jiri Pirko <jiri@resnulli.us>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@emulex.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I can send updates to other drivers, even though it's rather pointless
>> to update 1G drivers at this point for example. Please let me know,
>> but I'd prefer to do this in follow-up patches outside this first
>> patch series.
> [...]
>
> They should be changed to ensure they reject setting any of the high
> advertising flags, but it's not urgent.

if old drivers advertised a get/set_bits function while new drivers
advertised a get/set_new_bits function,
you could not updated any old drivers, and simply take care of
rejecting invalid bits in core, by calling set_new_bits if provided,
if not, rejecting bad bits and calling set_bits if no bad bits were
set.
