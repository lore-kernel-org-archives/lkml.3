Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbaHGJzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:55:52 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:3660
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757487AbaHGJzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:55:50 -0400
Date: Thu, 7 Aug 2014 17:44:05 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <timur@tabi.org>, <Li.Xiubo@freescale.com>,
        <devicetree@vger.kernel.org>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <b42378@freescale.com>,
        <b02247@freescale.com>
Subject: Re: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
Message-ID: <20140807094404.GB3088@MrMyself>
References: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
 <20140807094527.GC17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140807094527.GC17528@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(24454002)(51704005)(57704003)(81342001)(83072002)(85852003)(87936001)(106466001)(81542001)(85306004)(74502001)(19580395003)(6806004)(92566001)(64706001)(33716001)(84676001)(31966008)(15975445006)(21056001)(68736004)(92726001)(19580405001)(4396001)(74662001)(83322001)(46102001)(95666004)(105606002)(80022001)(44976005)(20776003)(47776003)(15202345003)(33656002)(107046002)(23726002)(54356999)(97736001)(50986999)(76176999)(76482001)(50466002)(104016003)(102836001)(83506001)(86362001)(110136001)(97756001)(99396002)(77982001)(79102001)(26826002)(46406003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB448;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029651C7A1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:45:27AM +0100, Mark Brown wrote:
> On Tue, Aug 05, 2014 at 03:32:05PM +0800, Nicolin Chen wrote:
> > From: Nicolin Chen <Guangyu.Chen@freescale.com>
> > 
> > SAI supports these operation modes:
> > 1) asynchronous mode
> >    Both Tx and Rx are set to be asynchronous.
> > 2) synchronous mode (Rx sync with Tx)
> >    Tx is set to be asynchronous, Rx is set to be synchronous.
> > 3) synchronous mode (Tx sync with Rx)
> >    Rx is set to be asynchronous, Tx is set to be synchronous.
> > 4) synchronous mode (Tx/Rx sync with another SAI's Tx)
> > 5) synchronous mode (Tx/Rx sync with another SAI's Rx)
> 
> This seems to conflict with something else on my branch - not checked
> what.  Can you take a look please?

Ah...there is another patch that should haven been merged into for-next
is currently missing on the remote branch.

This one:
http://mailman.alsa-project.org/pipermail/alsa-devel/2014-August/079689.html
 
> > +Note:
> > +- If both fsl,sai-asynchronous and fsl,sai-synchronous-rx are absent, the
> > +  default synchronous mode (sync Rx with Tx) will be used, which means both
> > +  transimitter and receiver will send and receive data by following clocks
> > +  of transimitter.
> > +- fsl,sai-asynchronous will be ignored if fsl,sai-synchronous-rx property is
> > +  already present.
> 
> Might be worth printing an error here.

Hmm...Do I need to send a v2?

Thank you
Nicolin
