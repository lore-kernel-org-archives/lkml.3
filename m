Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaHDLUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:20:48 -0400
Received: from mail-am1lrp0015.outbound.protection.outlook.com ([213.199.154.15]:52554
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752163AbaHDLUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:20:47 -0400
From: Dotan Barak <dotanb@mellanox.com>
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: checkpatch.pl report about "Missing blank line after declarations" in
 a structure definition
Thread-Topic: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
Thread-Index: Ac+v1hsr1olRx4GsR0yoGKahVltZOw==
Date: Mon, 4 Aug 2014 11:20:44 +0000
Message-ID: <3219ba81002f41d99c8651755dc2a920@DB3PR05MB380.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(41574002)(48214007)(199002)(189002)(52604005)(54356999)(74502001)(83322001)(106356001)(64706001)(229853001)(105586002)(21056001)(31966008)(110136001)(101416001)(80022001)(74662001)(76482001)(76576001)(20776003)(81342001)(66066001)(46102001)(19580395003)(77982001)(2656002)(95666004)(92566001)(107046002)(86362001)(4396001)(50986999)(33646002)(87936001)(83072002)(99396002)(74316001)(85852003)(15974865002)(81542001)(85306004)(79102001)(24736002)(108616003)(18886075002);DIR:OUT;SFP:;SCL:1;SRVR:DB3PR05MB379;H:DB3PR05MB380.eurprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe.

Thanks for fixing the issue that I reported about.

It seems that even after your fix, there is still a false warning of "Missing blank line after declarations".

I executed checkpatch.pl on a header file that exists in the Linux tree:
# ./checkpatch.pl --file --no-tree ../include/linux/mlx5/cq.h

And got the following warning:

WARNING: Missing a blank line after declarations
#49: FILE: ../include/linux/mlx5/cq.h:49:
+       int                     irqn;
+       void (*comp)            (struct mlx5_core_cq *);


Here is the structure that checkpatch.pl is complaining about:

<snip start>
struct mlx5_core_cq {
        u32                     cqn;
        int                     cqe_sz;
        __be32                 *set_ci_db;
        __be32                 *arm_db;
        atomic_t                refcount;
        struct completion       free;
        unsigned                vector;
        int                     irqn;
        void (*comp)            (struct mlx5_core_cq *);
        void (*event)           (struct mlx5_core_cq *, enum mlx5_event);
        struct mlx5_uar        *uar;
        u32                     cons_index;
        unsigned                arm_sn;
        struct mlx5_rsc_debug   *dbg;
        int                     pid;
};
<snip end>

As you can see, this is a structure definition and IMHO the warning above is false.


Thanks!

Dotan Barak
Sr. Staff Engineer, Windows verification
Mellanox Technologies
Beit Mellanox
Yokneam, 20692

Office: +972-74-7236271
Fax:     +972-4-9593245
www.mellanox.com

