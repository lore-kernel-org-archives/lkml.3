Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaLCRDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:03:18 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44905 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLCRDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:03:15 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/1] of-unittest: Deletion of an unnecessary check
 =?iso-8859-1?Q?before=0D?= the function call "of_node_put"
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
In-Reply-To: <547DB803.1080406@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<547DB803.1080406@users.sourceforge.net>
Date: Wed, 03 Dec 2014 17:03:11 +0000
Message-Id: <20141203170311.BADB8C40932@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2014 14:00:51 +0100
, SF Markus Elfring <elfring@users.sourceforge.net>
 wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 2 Dec 2014 13:54:00 +0100
> 
> The of_node_put() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied, thanks.

g.

> ---
>  drivers/of/unittest.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
> index cc0c5ec..06ebe9d 100644
> --- a/drivers/of/unittest.c
> +++ b/drivers/of/unittest.c
> @@ -486,8 +486,7 @@ static void __init of_selftest_changeset(void)
>  	/* Make sure node names are constructed correctly */
>  	selftest((np = of_find_node_by_path("/testcase-data/changeset/n2/n21")),
>  		 "'%s' not added\n", n21->full_name);
> -	if (np)
> -		of_node_put(np);
> +	of_node_put(np);
>  
>  	mutex_lock(&of_mutex);
>  	selftest(!of_changeset_revert(&chgset), "revert failed\n");
> -- 
> 2.1.3
> 

