Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbbAFONf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:13:35 -0500
Received: from mail-db3on0079.outbound.protection.outlook.com ([157.55.234.79]:19904
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751867AbbAFONd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:13:33 -0500
X-Greylist: delayed 953 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 09:13:33 EST
Message-ID: <54ABE991.3040107@mellanox.com>
Date: Tue, 6 Jan 2015 15:56:33 +0200
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Decotigny <ddecotig@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
CC: David Decotigny <decot@googlers.com>,
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
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Subject: Re: [PATCH net-next v2 0/8] net: extend ethtool link mode bitmaps
 to 48 bits
References: <1420512850-24699-1-git-send-email-ddecotig@gmail.com>
In-Reply-To: <1420512850-24699-1-git-send-email-ddecotig@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.8.17.220]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 193.47.165.134)
 smtp.mailfrom=amirv@mellanox.com; 
X-Forefront-Antispam-Report: CIP:193.47.165.134;CTRY:IL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(428002)(377454003)(24454002)(479174004)(199003)(189002)(87936001)(2501002)(62966003)(31966008)(76176999)(33656002)(77156002)(106466001)(2201001)(77096005)(68736005)(4396001)(36756003)(101416001)(50986999)(86362001)(97736003)(2950100001)(92566001)(65816999)(54356999)(107046002)(21056001)(99396003)(59896002)(120916001)(23746002)(46102003)(80316001)(105586002)(6806004)(84676001)(64126003)(50466002)(83506001)(47776003)(65806001)(20776003)(65956001)(64706001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:DB4PR05MB0943;H:mtlcas13.mtl.com;FPR:;SPF:None;MLV:sfv;PTR:ErrorRetry;A:1;MX:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DB4PR05MB0943;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB4PR05MB0943;
X-Forefront-PRVS: 0448A97BF2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB0943;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 13:57:34.5997
 (UTC)
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a652971c-7d2e-4d9b-a6a4-d149256f461b;Ip=[193.47.165.134]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR05MB0943
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB0863;
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2015 4:54 AM, David Decotigny wrote:
> This patch series increases the width of the supported/advertising
> ethtool masks from 32 bits to 48. This should allow to breathe for a
> couple more years (or... months?).
Hi,

Nice work.
What worries me is that it is going to be for weeks more than years or
months...

Mellanox is about to release next month a driver for a new NIC, with 3
new speeds * few link modes for each + new link modes for 10G.
It seems that we will need to consume almost all the new bits.

Amir
