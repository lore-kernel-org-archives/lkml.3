Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaHDOOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:14:22 -0400
Received: from mail-am1lrp0015.outbound.protection.outlook.com ([213.199.154.15]:41376
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752097AbaHDOOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:14:21 -0400
From: Dotan Barak <dotanb@mellanox.com>
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
Thread-Topic: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
Thread-Index: Ac+v1hsr1olRx4GsR0yoGKahVltZOwAEuFMAAAD6CqA=
Date: Mon, 4 Aug 2014 14:14:16 +0000
Message-ID: <e68ad593255b4094a79de9b22cbc2a7a@DB3PR05MB380.eurprd05.prod.outlook.com>
References: <3219ba81002f41d99c8651755dc2a920@DB3PR05MB380.eurprd05.prod.outlook.com>
 <1407159342.16152.63.camel@joe-AO725>
In-Reply-To: <1407159342.16152.63.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(41574002)(377424004)(52604005)(51704005)(199002)(189002)(24454002)(19580405001)(74662001)(106356001)(83322001)(19580395003)(85852003)(81342001)(33646002)(83072002)(66066001)(80022001)(81542001)(50986999)(64706001)(110136001)(87936001)(105586002)(86362001)(76176999)(99396002)(76576001)(15975445006)(101416001)(2656002)(46102001)(74502001)(77982001)(20776003)(95666004)(4396001)(76482001)(54356999)(85306004)(74316001)(79102001)(107046002)(21056001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:DB3PR05MB378;H:DB3PR05MB380.eurprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe.

The patch that you mentioned solved most of the issues, thanks!

However, there is still one more warning of this type within a struct declaration.

# ./checkpatch.pl --file --no-tree ../include/linux/mlx5/driver.h

WARNING: Missing a blank line after declarations
#508: FILE: ../include/linux/mlx5/driver.h:508:
+       struct mlx5_uuar_info   uuari;
+       MLX5_DECLARE_DOORBELL_LOCK(cq_uar_lock);


<snip start>
struct mlx5_priv {
        char                    name[MLX5_MAX_NAME_LEN];
        struct mlx5_eq_table    eq_table;
        struct mlx5_uuar_info   uuari;
        MLX5_DECLARE_DOORBELL_LOCK(cq_uar_lock);

        /* pages stuff */
        struct workqueue_struct *pg_wq;
        struct rb_root          page_root;
        int                     fw_pages;
        int                     reg_pages;
        struct list_head        free_list;

<snip end>


Thanks
Dotan

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Monday, August 04, 2014 4:36 PM
> To: Dotan Barak
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: checkpatch.pl report about "Missing blank line after
> declarations" in a structure definition
> 
> On Mon, 2014-08-04 at 11:20 +0000, Dotan Barak wrote:
> > Hi Joe.
> >
> > Thanks for fixing the issue that I reported about.
> >
> > It seems that even after your fix, there is still a false warning of "Missing
> blank line after declarations".
> >
> > I executed checkpatch.pl on a header file that exists in the Linux tree:
> > # ./checkpatch.pl --file --no-tree ../include/linux/mlx5/cq.h
> >
> > And got the following warning:
> >
> > WARNING: Missing a blank line after declarations
> > #49: FILE: ../include/linux/mlx5/cq.h:49:
> > +       int                     irqn;
> > +       void (*comp)            (struct mlx5_core_cq *);
> []
> > As you can see, this is a structure definition and IMHO the warning above is
> false.
> 
> The version in Linus' tree has a defect where this test doesn't recognize
> function pointer declarations.
> 
> This is fixed in -next since June, but it takes awhile to get into Linus' tree.
> 
> https://lkml.org/lkml/2014/6/6/426
> 

