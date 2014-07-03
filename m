Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbaGCSJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:09:14 -0400
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:47879 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbaGCSJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:09:13 -0400
X-MXL-Hash: 53b59c485679c5b0-5a25c81cd17f92cb4998833e856156dbf7fc1c07
X-MXL-Hash: 53b596be50794802-ee2d30f610a4c617385a33ab35b5627f0460b5af
Date: Thu, 3 Jul 2014 13:45:22 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
X-X-Sender: jlaw@jlaw-desktop.mno.stratus.com
To: Christoph Hellwig <hch@infradead.org>
CC: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, <support@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <DL-MPTFusionLinux@lsi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c:  Fix for possible null
 pointer dereference
In-Reply-To: <20140528112628.GB11953@infradead.org>
Message-ID: <alpine.DEB.2.02.1407031331520.9641@jlaw-desktop.mno.stratus.com>
References: <1400429439-11184-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <20140528112628.GB11953@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=UtftNoAB c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=nXGuE6rTyBAA:10 a=GE6]
X-AnalysisOut: [ro8ibXLwA:10 a=_KQqW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmw]
X-AnalysisOut: [cHowA:10 a=kj9zAlcOel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxIAAAA]
X-AnalysisOut: [:8 a=9S-bDqZZL2aVF5IOM10A:9 a=CjuIK1q_8ugA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014070310); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Christoph Hellwig wrote:

> > -	ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
> > +	if (mpi_reply) {
> > +		ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
> > +	}
> >  
> >  	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
> >  		ioc->port_enable_failed = 1;
> 
> ioc_status isn't initialized without the reply and used here as well
> as later in the function.  I think we'll need input from LSI or others
> with the spec on what to do when we didn't get a reply.

Any update on this? 

The mpt3 version checks for !mpi_reply and returns 1.  Which leads to 
another question -- should mpt{2,3}sas_port_enable_done ever return 0 (as their 
respective comments describe)?

Regards,

-- Joe
