Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaFGLnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 07:43:00 -0400
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:56428 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752425AbaFGLm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 07:42:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3871:3872:3873:4321:5007:7652:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12438:12517:12519:12740:13019:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: baby26_36e19022edb1f
X-Filterd-Recvd-Size: 1797
Message-ID: <1402141375.28369.2.camel@joe-AO725>
Subject: Re: [PATCH] net: wimax: i2400m: control.c:  Cleaning up conjunction
 always evaluates to false
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 07 Jun 2014 04:42:55 -0700
In-Reply-To: <1402140397-17404-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402140397-17404-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-07 at 13:26 +0200, Rickard Strandqvist wrote:
> Logical conjunction always evaluates to false:  minor < 2 && minor > 1
> I guess what you wanted is rather: minor > 2 || minor < 1
[]
> diff --git a/drivers/net/wimax/i2400m/control.c b/drivers/net/wimax/i2400m/control.c
[]
> @@ -1061,7 +1061,7 @@ int i2400m_firmware_check(struct i2400m *i2400m)
>  		goto error_bad_major;
>  	}
>  	result = 0;
> -	if (minor < I2400M_HDIv_MINOR_2 && minor > I2400M_HDIv_MINOR)
> +	if (minor > I2400M_HDIv_MINOR_2 || minor < I2400M_HDIv_MINOR)

perhaps clearer as:

	if (!(minor == I2400M_HDIv_MINOR || minor == I2400M_HDIv_MINOR_2))

>  		dev_warn(dev, "untested minor fw version %u.%u.%u\n",
>  			 major, minor, branch);
>  	/* Yes, we ignore the branch -- we don't have to track it */



