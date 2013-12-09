Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761159Ab3LISey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:34:54 -0500
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:35316 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755710Ab3LISex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:34:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:4605:5007:7576:7652:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12663:12679:12740:13069:13071:13161:13229:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dad74_d05ad840a708
X-Filterd-Recvd-Size: 2528
Message-ID: <1386614088.8168.12.camel@joe-AO722>
Subject: Re: [PATCH v2] Staging: TIDSPBRIDGE: Remove UUID helper
From: Joe Perches <joe@perches.com>
To: Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>
Cc: gregkh@linuxfoundation.org, omar.ramirez@copitl.com, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Date: Mon, 09 Dec 2013 10:34:48 -0800
In-Reply-To: <1386583996-5648-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20131208071857.GA12104@kroah.com>
	 <1386583996-5648-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 12:13 +0200, Ivaylo DImitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
> 
> Custom uuid helper function is needed only in rmgr/dbdcd.c and doesn't
> need to be exported. It can also be made way simpler by using sscanf.

Hi Ivaylo.

Trivial notes:

The function name change in dbcdc.c from
uuid_uuid_from_string to dcd_uuid_from_string
seems unnecessary.

If you are going to change the name, please
also reindent the multi-line statements to the
open parenthesis as the rest of the file has
that style.

> diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
[]
> @@ -1001,7 +1042,7 @@ static int get_attrs_from_buf(char *psz_buf, u32 ul_buf_size,
>  		token = strsep(&psz_cur, seps);
>  
>  		/* dsp_uuid ui_node_id */
> -		uuid_uuid_from_string(token,
> +		dcd_uuid_from_string(token,
>  				      &gen_obj->obj_data.node_obj.ndb_props.
>  				      ui_node_id);
>  		token = strsep(&psz_cur, seps);

The 2nd and 3rd lines of dcd_uuid_from_string
should be moved 1 left.

> @@ -1400,7 +1441,7 @@ static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
>  				break;
>  			} else {
>  				/* Retrieve UUID string. */
> -				uuid_uuid_from_string(token,
> +				dcd_uuid_from_string(token,
>  						      &(dep_lib_uuids
>  							[dep_libs]));
>  				/* Is this library persistent? */

here too.

It also appears as if these could set status
to the from_string return value and error-out
when non-zero.


