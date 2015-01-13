Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbbAMNa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:30:57 -0500
Received: from mail-db3on0092.outbound.protection.outlook.com ([157.55.234.92]:49010
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751093AbbAMNa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:30:56 -0500
Message-ID: <54B51E01.20509@ezchip.com>
Date: Tue, 13 Jan 2015 08:30:41 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2 22/40] tile: fix put_user sparse errors
References: <1420558883-10131-1-git-send-email-mst@redhat.com> <1420558883-10131-23-git-send-email-mst@redhat.com> <54B44326.6010501@ezchip.com> <20150113093535.GA4434@redhat.com>
In-Reply-To: <20150113093535.GA4434@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.76.21.154]
X-ClientProxiedBy: BLUPR11CA0055.namprd11.prod.outlook.com (10.141.30.23) To
 DB4PR02MB0542.eurprd02.prod.outlook.com (10.141.45.15)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=cmetcalf@ezchip.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DB4PR02MB0542;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB4PR02MB0542;
X-Forefront-PRVS: 045584D28C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(479174004)(377454003)(189002)(199003)(52314003)(24454002)(47776003)(65806001)(65956001)(33656002)(64706001)(86362001)(87976001)(19580395003)(66066001)(83506001)(92566002)(15975445007)(40100003)(77096005)(110136001)(68736005)(2950100001)(101416001)(122386002)(93886004)(105586002)(117156001)(106356001)(97736003)(23746002)(50466002)(42186005)(65816999)(50986999)(54356999)(76176999)(46102003)(62966003)(77156002)(36756003)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB4PR02MB0542;H:[192.168.1.160];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB4PR02MB0542;
X-OriginatorOrg: ezchip.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 13:30:52.4118 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR02MB0542
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/2015 4:35 AM, Michael S. Tsirkin wrote:
> I wonder why didn't
> kbuild notify me about new warnings. Doesn't it build tile?

Kbuild builds tilegx, which is an LP64 kernel.  These issues are with the
older platform, tilepro, which is an ILP32 kernel.

There's certainly no reason we couldn't be building that with kbuild
as well, but for whatever reason it just never started up, and I'm
primarily concerned with tilegx anyway, so I haven't pushed.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

