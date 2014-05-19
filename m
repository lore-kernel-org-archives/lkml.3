Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaESLj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:39:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaESLj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:39:56 -0400
Message-ID: <1400499593.31716.16.camel@linux-fkkt.site>
Subject: Re: [PATCH] scsi: dc395x.c:  Fix for possible null pointer
 dereference
From: Oliver Neukum <oneukum@suse.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 19 May 2014 13:39:53 +0200
In-Reply-To: <Pine.LNX.4.64.1405182147500.23804@axis700.grange>
References: <1400429349-11040-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <Pine.LNX.4.64.1405182147500.23804@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-18 at 21:50 +0200, Guennadi Liakhovetski wrote:
> On Sun, 18 May 2014, Rickard Strandqvist wrote:
> 
> > There is otherwise a risk of a possible null pointer dereference.
> > 
> > Was largely found by using a static code analysis program called cppcheck.
> > 
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > ---
> >  drivers/scsi/dc395x.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> > index 83d9bf6..0d86bc7 100644
> > --- a/drivers/scsi/dc395x.c
> > +++ b/drivers/scsi/dc395x.c
> > @@ -2637,7 +2637,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
> >  	struct ScsiReqBlk *srb = NULL;
> >  	struct ScsiReqBlk *i;
> >  	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
> > -		   srb->cmd, tag, srb);
> > +		   srb ? srb->cmd : 0, tag, srb);
> 
> There's not just a risk, it is a NULL-pointer dereference, so, just remove 
> it, e.g. like

Indeed. Thank you both for catching this.

	Regards
		Oliver



