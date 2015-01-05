Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbbAESRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:17:01 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:58061 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbAESQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:16:56 -0500
MIME-Version: 1.0
In-Reply-To: <1420425003.5686.155.camel@decadent.org.uk>
References: <1420405017-23278-1-git-send-email-ddecotig@gmail.com>
 <1420408540.5686.140.camel@decadent.org.uk> <CAHo-Ooxi8V_58b456vePY9_7ChuBe0jxEVHvGkGvRBpAR744yA@mail.gmail.com>
 <1420425003.5686.155.camel@decadent.org.uk>
From: David Decotigny <ddecotig@gmail.com>
Date: Mon, 5 Jan 2015 10:16:35 -0800
X-Google-Sender-Auth: ZciJfetcRkf7xPbyQVGKrNUgPnI
Message-ID: <CAG88wWZMPNb+mw-T1DNgHn=n8MeimEDY+KJ15KGbvoZMuKeQBw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 0/7] net: extend ethtool link mode bitmaps to
 48 bits
To: Ben Hutchings <ben@decadent.org.uk>
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Amir Vadai <amirv@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ben, I will send an updated version.

About rejecting high bits in drivers that don't support them: a basic
fix (in a separate patch series) could be something like follows in
ethtool_set_settings callbacks:  if (ecmd->advertising_hi) return
-EINVAL; with comments. But I don't find it very nice. Or: allocate a
new net_device::priv_flags bit and ask net/core/ethtool.c to accept
high advertising bits only when this flag is set? Any preference/other
options?

Related: lately, each new class of link modes declared == 4 new bits
allocated. At current pace these 16 new bits buy us only 4 new
classes, ie. a little more than 5 years if I extrapolate from the
recent past. Is the longer term plan to create a new ethtool ioctl
command specialized in link modes with variable length masks? Or to
switch to a brand new netlink interface altogether and take advantage
of that to revisit the link mode reporting/configuration with variable
length masks?

On Sun, Jan 4, 2015 at 6:30 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Mon, 2015-01-05 at 01:34 +0100, Maciej Żenczykowski wrote:
>> >> I can send updates to other drivers, even though it's rather pointless
>> >> to update 1G drivers at this point for example. Please let me know,
>> >> but I'd prefer to do this in follow-up patches outside this first
>> >> patch series.
>> > [...]
>> >
>> > They should be changed to ensure they reject setting any of the high
>> > advertising flags, but it's not urgent.
>>
>> if old drivers advertised a get/set_bits function while new drivers
>> advertised a get/set_new_bits function,
>> you could not updated any old drivers, and simply take care of
>> rejecting invalid bits in core, by calling set_new_bits if provided,
>> if not, rejecting bad bits and calling set_bits if no bad bits were
>> set.
>
> We've never checked that the reserved fields are zero before, and I
> think there are still drivers that don't fully validate the existing 32
> bits.  So while I think drivers should fully validate the advertising
> flags, userland generally can't assume they do.  And therefore I don't
> think it's worth adding complexity to the ethtool core that only partly
> fixes this.
>
> Ben.
>
> --
> Ben Hutchings
> This sentence contradicts itself - no actually it doesn't.
