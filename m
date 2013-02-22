Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3BVJMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:12:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53247 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3BVJMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:12:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH v4] mfd: syscon: Add non-DT support
Date: Fri, 22 Feb 2013 09:11:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Dong Aisheng <b29396@freescale.com>, Alexander Shiyan <shc_work@mail.ru>,
        linux-kernel@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        gregkh@linuxfoundation.org
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru> <20130222071311.GB3252@b29396-Latitude-E6410> <20130222072718.GA24114@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130222072718.GA24114@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302220911.53537.arnd@arndb.de>
X-Provags-ID: V02:K0:PvpkfN2RvbRe6pwoF6aqeV2x9sOrkmClh6vjiEIHBYr
 j2d6QEn5pXCFuTbKlb4SU7KP3y5xB/5Z8dFwd4A0VCCSTu6/GC
 anZwmNuc6NSiJluENWE1altCmIlSnT6P//nH2ia2N41mOA4Gog
 BOF1k8MH9GWouxKYmZcnwlSxfLMl5yWwxwzOuiiIXfA2Frv4w6
 +Fc29+sEPcpBM/NL88TXBSaSkHKPL+8XJ/9BAL8lfXiUrLoZDe
 JMYaEVzEbkxbcfnpL1AzTCYtOU+a5mW1JDKDmZ/CKLaNbKo7X8
 Ti1VBbzUBEco8dHH308QYSwAfpzalX8jpNgiKWMyV0RCVgR9kG
 nB+wP7inDbBmts1GRdfI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2013, Thierry Reding wrote:
> On Fri, Feb 22, 2013 at 03:13:12PM +0800, Dong Aisheng wrote:
> > On Fri, Feb 22, 2013 at 11:01:18AM +0400, Alexander Shiyan wrote:
> > > > On Thu, Feb 21, 2013 at 07:29:02PM +0400, Alexander Shiyan wrote:
> > > > > This patch allow using syscon driver from the platform data, i.e.
> > > > > possibility using driver on systems without oftree support.
> > > > > For search syscon device from the client drivers,
> > > > > "syscon_regmap_lookup_by_pdevname" function was added.
> > > > > 
> > > > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > > > 
> > > > [...]
> > > > 
> > > > > +       syscon->base = devm_ioremap_resource(dev, res);
> > > > > +       if (!syscon->base)
> > > > 
> > > > Is this correct?
> > > 
> > > Hmm, of course IS_ERR should be used here...
> > > v5?
> > > 
> > 
> > Yes.
> > >From here:
> > https://lkml.org/lkml/2013/1/21/140
> > It seems it is.
> 
> Yes, devm_ioremap_resource() never returns NULL. You always need to
> check the returned pointer with IS_ERR(). The value that you return
> should be extracted from the pointer with PTR_ERR().
> 

Well, devm_ioremap_resource also tries to request the resource, which
as someone (Dong or Shawn?) pointed out, we should not do for the imx6q
case. I think this has to be reverted to platform_get_resource
and dev_ioremap.

	Arnd
