Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbbABUsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:48:33 -0500
Received: from mail-bn1bon0144.outbound.protection.outlook.com ([157.56.111.144]:7233
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751832AbbABUsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:48:32 -0500
Date: Fri, 2 Jan 2015 12:14:26 -0800
From: Insop Song <insop.song@gainspeed.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        =?utf-8?Q?Micha=C5=82?= Bartoszkiewicz 
	<mbartoszkiewicz@gmail.com>,
        Rocco Folino <lordzen87@gmail.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: gs_fpgaboot: io.c:  Remove unused function
Message-ID: <20150102201426.GA15696@neon.local.cohere.net>
References: <1420129393-29038-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420129393-29038-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [157.56.236.245]
X-ClientProxiedBy: BLUPR07CA0103.namprd07.prod.outlook.com (10.255.223.174) To
 BY1PR0701MB1317.namprd07.prod.outlook.com (25.160.108.27)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Insop.Song@gainspeed.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY1PR0701MB1317;
X-Forefront-PRVS: 0444EB1997
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(189002)(199003)(110136001)(77156002)(50986999)(46406003)(76176999)(31966008)(40100003)(106356001)(19580405001)(23726002)(50466002)(120916001)(20776003)(19580395003)(64706001)(83506001)(54356999)(87976001)(47776003)(122386002)(105586002)(101416001)(86362001)(21056001)(4396001)(33656002)(97736003)(98436002)(107046002)(97756001)(2950100001)(66066001)(42186005)(46102003)(68736005)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0701MB1317;H:BY2PRD0210HT002.namprd02.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: gainspeed.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2015 20:14:40.4105 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0701MB1317
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Insop Song <Insop.Song@gainspeed.com>

Thank you,

ISS

On Thu, Jan 01, 2015 at 05:23:13PM +0100, Rickard Strandqvist wrote:
> Remove the function bitswap() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/gs_fpgaboot/io.c |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/staging/gs_fpgaboot/io.c b/drivers/staging/gs_fpgaboot/io.c
> index b260e45..819db53 100644
> --- a/drivers/staging/gs_fpgaboot/io.c
> +++ b/drivers/staging/gs_fpgaboot/io.c
> @@ -79,15 +79,6 @@ void xl_shift_bytes_out(enum wbus bus_byte, unsigned char *pdata)
>  /*
>   * generic bit swap for xilinx SYSTEMMAP FPGA programming
>   */
> -static inline unsigned char bitswap(unsigned char s)
> -{
> -	unsigned char d;
> -
> -	d = (((s&0x80)>>7) | ((s&0x40)>>5) | ((s&0x20)>>3) | ((s&0x10)>>1) |
> -		((s&0x08)<<1) | ((s&0x04)<<3) | ((s&0x02)<<5) | ((s&0x01)<<7));
> -	return d;
> -}
> -
>  void xl_program_b(int32_t i)
>  {
>  }
> -- 
> 1.7.10.4
> 
