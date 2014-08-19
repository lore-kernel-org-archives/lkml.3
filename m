Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaHSWTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 18:19:22 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:18148
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751688AbaHSWTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 18:19:21 -0400
Message-ID: <1408486751.4058.37.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc: Make 256k pages depend on PPC32=n
From: Scott Wood <scottwood@freescale.com>
To: Pranith Kumar <bobby.prani@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 19 Aug 2014 17:19:11 -0500
In-Reply-To: <1408484166-20711-1-git-send-email-bobby.prani@gmail.com>
References: <1408484166-20711-1-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:70b6:fbcb:548e:4486]
X-ClientProxiedBy: CO1PR06CA053.namprd06.prod.outlook.com (10.242.160.43) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019006)(6009001)(199003)(377424004)(24454002)(189002)(51704005)(101416001)(50466002)(74662001)(92566001)(76482001)(95666004)(88136002)(87976001)(21056001)(79102001)(83072002)(89996001)(87286001)(85852003)(77096002)(107046002)(4396001)(80022001)(83322001)(77982001)(33646002)(110136001)(76176999)(102836001)(64706001)(77156001)(81542001)(23676002)(19580405001)(47776003)(20776003)(46102001)(42186005)(93916002)(86362001)(92726001)(106356001)(81342001)(50226001)(62966002)(74502001)(103116003)(99396002)(50986999)(19580395003)(31966008)(85306004)(104166001)(105586002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:70b6:fbcb:548e:4486];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 17:36 -0400, Pranith Kumar wrote:
> 256k pages are not tested on PPC32. On a randconfig I got the following error:
> 
> arch/powerpc/kernel/misc_32.S:1171: Error: operand out of range (0x0000000000010000 is not between 0xffffffffffff8000 and 0x0000000000007fff)
> 
> Disable 256K pages if PPC32=y
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  arch/powerpc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index da16ffe..6cc518f 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -556,7 +556,7 @@ config PPC_64K_PAGES
>  
>  config PPC_256K_PAGES
>  	bool "256k page size" if 44x
> -	depends on !STDBINUTILS
> +	depends on !PPC32 && !STDBINUTILS
>  	help
>  	  Make the page size 256k.
>  

How will this ever be selected then?  44x is 32-bit only.

-Scott


