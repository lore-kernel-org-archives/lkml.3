Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaHDOuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:50:08 -0400
Received: from mail-db3lrp0079.outbound.protection.outlook.com ([213.199.154.79]:4226
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752357AbaHDOuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:50:05 -0400
From: Dotan Barak <dotanb@mellanox.com>
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
Thread-Topic: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
Thread-Index: Ac+v1hsr1olRx4GsR0yoGKahVltZOwAEuFMAAAD6CqAAANNzgAAAjzTw
Date: Mon, 4 Aug 2014 14:50:01 +0000
Message-ID: <f95137f9228a4f08ba391f9640237d28@DB3PR05MB380.eurprd05.prod.outlook.com>
References: <3219ba81002f41d99c8651755dc2a920@DB3PR05MB380.eurprd05.prod.outlook.com>
	 <1407159342.16152.63.camel@joe-AO725>
	 <e68ad593255b4094a79de9b22cbc2a7a@DB3PR05MB380.eurprd05.prod.outlook.com>
 <1407162439.16152.67.camel@joe-AO725>
In-Reply-To: <1407162439.16152.67.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(979002)(6009001)(24454002)(377454003)(51704005)(13464003)(189002)(199002)(41574002)(377424004)(51444003)(106356001)(86362001)(83072002)(95666004)(107046002)(80022001)(81542001)(31966008)(54356999)(85852003)(76576001)(74316001)(81342001)(77982001)(50986999)(105586002)(83322001)(19580405001)(64706001)(19580395003)(101416001)(110136001)(76482001)(20776003)(79102001)(92566001)(2656002)(99396002)(21056001)(74502001)(76176999)(74662001)(87936001)(46102001)(33646002)(4396001)(93886004)(85306004)(66066001)(24736002)(108616003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:DB3PR05MB380;H:DB3PR05MB380.eurprd05.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that allowing a prefix is reasonable (to allow modules to add more flexibility).
I tried the suggested change and it still didn't work for me.

The following change worked for me:
(?:$Storage\s+)?[A-Z0-9_]*(?:DECLARE|DEFINE)_[A-Z_]*\s*\(|

But, maybe it is better to be even more general and allow:
(?:$Storage\s+)?[A-Z0-9_]*(?:DECLARE|DEFINE)_[ A-Z0-9_]*\s*\(|


Thanks a lot for the quick (and great) response!
Dotan

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Monday, August 04, 2014 5:27 PM
> To: Dotan Barak
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: checkpatch.pl report about "Missing blank line after
> declarations" in a structure definition
> 
> On Mon, 2014-08-04 at 14:14 +0000, Dotan Barak wrote:
> > Hi Joe.
> >
> > The patch that you mentioned solved most of the issues, thanks!
> >
> > However, there is still one more warning of this type within a struct
> declaration.
> >
> > # ./checkpatch.pl --file --no-tree ../include/linux/mlx5/driver.h
> >
> > WARNING: Missing a blank line after declarations
> > #508: FILE: ../include/linux/mlx5/driver.h:508:
> > +       struct mlx5_uuar_info   uuari;
> > +       MLX5_DECLARE_DOORBELL_LOCK(cq_uar_lock);
> >
> >
> > <snip start>
> > struct mlx5_priv {
> >         char                    name[MLX5_MAX_NAME_LEN];
> >         struct mlx5_eq_table    eq_table;
> >         struct mlx5_uuar_info   uuari;
> >         MLX5_DECLARE_DOORBELL_LOCK(cq_uar_lock);
> 
> MLX5_DECLARE_DOORBELL is not a "normal" DECLARE macro.
> 
> Perhaps the exception for the DECLARE_<FOO> declaration macros in the
> exceptions list:
> 
> 	(?:$Storage\s+)?(?:DECLARE|DEFINE)_[A-Z]+\s*\(|
> 
> could be expanded to:
> 
> 	(?:$Storage\s+)?[A-Z0-9_]*(?:DECLARE|DEFINE)_[A-Z]+\s*\(|
> 

