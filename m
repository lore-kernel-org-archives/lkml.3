Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbaLBXsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:48:40 -0500
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:33380 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932722AbaLBXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:48:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3870:3871:4321:5007:6119:6120:6261:7901:7903:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13161:13229:13311:13357:13894:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: heart34_10f085953ac01
X-Filterd-Recvd-Size: 2174
Message-ID: <1417564115.2902.8.camel@perches.com>
Subject: Re: [tpmdd-devel] [PATCH v8 0/8] TPM 2.0 support
From: Joe Perches <joe@perches.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, tpmdd-devel@lists.sourceforge.net,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        linux-kernel@vger.kernel.org, jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Date: Tue, 02 Dec 2014 15:48:35 -0800
In-Reply-To: <201412030033.56705.PeterHuewe@gmx.de>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <201412030021.07882.PeterHuewe@gmx.de>
	 <20141202232442.GB14524@fuloong-minipc.musicnaut.iki.fi>
	 <201412030033.56705.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 00:33 +0100, Peter Hüwe wrote:
> Am Mittwoch, 3. Dezember 2014, 00:24:43 schrieb Aaro Koskinen:
> > On Wed, Dec 03, 2014 at 12:21:07AM +0100, Peter Hüwe wrote:
> > > --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> > > +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> > > @@ -605,10 +605,8 @@ static int i2c_nuvoton_probe(struct i2c_client
> > > *client,
> > > 
> > >  		return -ENODEV;
> > >  	
> > >  	rc = tpm_chip_register(chip);
> > > 
> > > -	if (rc)
> > > -		return rc;
> > > 
> > > -	return 0;
> > > +	return rc;
> > 
> > Maybe just return tpm_chip_register(chip)?
> 
> Even better.

The pattern:

	foo = bar();
	if (foo)
		return foo;

	return 0;

is fairly common.

There are a few hundred in the kernel.

$ grep-2.5.4 -nrP --include=*.[ch] "\b(\w+)\s*=\s*[^;]*;\s*if\s*\(\s*\1\s*\)\s*return\s*\1\s*;\s*return\s*0;" * | \
  grep -oP '^.+:\d+:' | \
  wc -l
308


