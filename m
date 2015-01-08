Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbbAHIks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:40:48 -0500
Received: from mail-db3on0083.outbound.protection.outlook.com ([157.55.234.83]:32504
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753894AbbAHIkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:40:45 -0500
Message-ID: <54AE4282.20009@mellanox.com>
Date: Thu, 8 Jan 2015 10:40:34 +0200
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Decotigny <ddecotig@gmail.com>
CC: Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Ben Hutchings <ben@decadent.org.uk>,
        "Masatake YAMATO" <yamato@redhat.com>, Xi Wang <xii@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        Tom Gundersen <teg@jklm.no>, Jiri Pirko <jiri@resnulli.us>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@emulex.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Subject: Re: [PATCH net-next v2 0/8] net: extend ethtool link mode bitmaps
 to 48 bits
References: <1420512850-24699-1-git-send-email-ddecotig@gmail.com>
 <54ABE991.3040107@mellanox.com>
 <CAG88wWYPDpwkWkL+Pj2VKrX5WVp=at8v0=gcFAVAA8nntv+-nw@mail.gmail.com>
In-Reply-To: <CAG88wWYPDpwkWkL+Pj2VKrX5WVp=at8v0=gcFAVAA8nntv+-nw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.206.129.61]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 193.47.165.134)
 smtp.mailfrom=amirv@mellanox.com; 
X-Forefront-Antispam-Report: CIP:193.47.165.134;CTRY:IL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(428002)(51444003)(51704005)(377454003)(24454002)(479174004)(199003)(189002)(1411001)(54356999)(33656002)(77156002)(62966003)(87936001)(2950100001)(31966008)(4396001)(65816999)(92566001)(50986999)(86362001)(97736003)(101416001)(76176999)(110136001)(21056001)(77096005)(107046002)(99396003)(120916001)(46102003)(50466002)(23676002)(64126003)(105586002)(84676001)(106466001)(6806004)(36756003)(68736005)(65956001)(64706001)(65806001)(20776003)(83506001)(47776003)(7059030)(19627235001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB4PR05MB0768;H:mtlcas13.mtl.com;FPR:;SPF:None;MLV:sfv;PTR:ErrorRetry;A:1;MX:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DB4PR05MB0768;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB4PR05MB0768;
X-Forefront-PRVS: 0450A714CB
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB0768;
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2015 08:40:39.7302
 (UTC)
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a652971c-7d2e-4d9b-a6a4-d149256f461b;Ip=[193.47.165.134]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR05MB0768
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2015 7:36 PM, David Decotigny wrote:
> Interesting. It seems that the band-aid I was proposing is already
> obsolete. We could still use the remaining reserved 16 bits to encode
> 5 more bits per mask (that is: 53 bits / mask total). But if I
> understand you, it would allow us to survive only a few months longer,
> as opposed to a few weeks.
> 
> One short-term alternative solution I can imagine is the following:
> /* For example bitmap-based for variable length: */
> struct ethtool_link_mode {
>   __u32 cmd;
>   __u8 autoneg :1;
>   __u8 duplex :2;
>  __u16 supported_nbits;
>   __u16 advertising_nbits;
>   __u16 lp_advertising_nbits;
>   __u32 reserved[4];
>   __u8 masks[0];
> };
> /* Or simpler, statically limited to 64b / mask, but easier to migrate
> to for driver authors: */
I think the first options is better. A driver will have to do changes in
order to support >32 link modes, so better change it once now, without
having to change it again for >64 link modes.

> struct ethtool_link_mode {
>   __u32 cmd;
>   __u8 autoneg :1;
>   __u8 duplex :2;
>    __u64 supported;
>   __u64 advertising;
>   __u64 lp_advertising;
>   __u32 reserved[4];
> };
> #define ETHTOOL_GLINK_MODE 0x0000004a
> #define ETHTOOL_SLINK_MODE 0x0000004b
> struct ethtool_ops {
> ...
>    int (*get_link_mode)(struct net_device *, struct ethtool_link_mode *);
>    int (*set_link_mode)(struct net_device *, struct ethtool_link_mode *);
> };
> 
> The same thing required for EEE.
Yeh :(

> 
> I am not sure about moving the autoneg and duplex fields into the new
> struct. Especially the "duplex" field.
I think so too. ethtool user space will call ETHTOOL_[GS]SET and after
that ETHTOOL_[GS]LINK_MODE (if supported). No need to get the
duplex/autoneg fields again.

> 
> Then the idea would be to update the ethtool user-space tool to try
> get/set_link mode when reporting/changing the autoneg/advertising
> settings.
> 
> Both will require significant effort from the driver authors.
> Especially if the variable-length bitmap approach is preferred:
>  - most drivers currently use simple bitwise arithmetic in their code,
> and that goes far beyond get/set_settings, it is sometimes part of the
> core driver logic. They will have to migrate to the bitmap API if they
> want to use the larger bitmaps (note: no change needed if they are
> happy with <= 32b / mask)
As I said above, it will save as doing this work again in the future,
and more problematic, save another version to backport in the future. In
addition, not all drivers will have to do it, only if >32 link speeds is
needed - this work will be required.

>  - we would have to progressively deprecate the use of #define
> ADVERTISED_1000baseT_Full in favor of an enum of the bit indices.
Maybe we could use some macro juggling to define the legacy macro's
using enum for the first 32 bits, and fail the compilation if used on
>32. For example, calling this:
DEFINE_LINK_MODE(ADVERTISED_1000baseT_Full, 5)

Will add the following:
ADVERTISED_1000baseT_Full_SHIFT = 5
ADVERTISED_1000baseT_Full = (1<<5)

DEFINE_LINK_MODE(ADVERTISED_100000baseKR5_Full, 50) will add:
ADVERTISED_100000baseKR5_Full_SHIFT = 50
ADVERTISED_100000baseKR5_Full = #error new link speeds must be defined
using [gs]et_link_speed

This will break compilation if ADVERTISED_100000baseKR5_Full is used in
[gs]et_settings (I know the '#error' will not print something very
pretty - I used it only to explain what I meant)

> 
> Any feedback welcome. In the meantime, I am going to propose a v3 of
> current option with 53 bits / mask. I can also propose a prototype of
> the scheme described above, please let me know.
I think that it is better to do it once, and skip the 53 bits / mask
version.
I'll be happy to assist.

Amir
