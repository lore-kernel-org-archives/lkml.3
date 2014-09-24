Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaIXUNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:13:08 -0400
Received: from mout.gmx.net ([212.227.15.19]:61895 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaIXUND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:13:03 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v1 03/12] tpm: TPM2 support for tpm_pcr_read()
Date: Wed, 24 Sep 2014 22:14:24 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.2-dirty; KDE/4.12.5; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        tpmdd-devel@lists.sourceforge.net,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com> <20140924165320.GD8898@obsidianresearch.com> <20140924194323.GE6801@intel.com>
In-Reply-To: <20140924194323.GE6801@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409242214.25273.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:YETAWY33nESVx6OKM5MYXNYofIQ9Ni47mRxkdIpXvsRqoU1932k
 xUM+t/nrOpZK2OLikyi7MB3RiO1dlMjLXTWmDav6I8FYxHrYEV3NC/kukY9VoIpx0zI6sJA
 5Pwksd9Sd6L6PNzVywcoGlgnZwb9Qd+MfgF/n8D6N8fWrgYewpd5tj277qCbtrGsZZXNHRX
 Y8SxS6YCoNAywFkIBuGfw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. September 2014, 21:43:23 schrieb Jarkko Sakkinen:
> On Wed, Sep 24, 2014 at 10:53:20AM -0600, Jason Gunthorpe wrote:
> > On Wed, Sep 24, 2014 at 12:05:53PM +0300, Jarkko Sakkinen wrote:
> > > +static struct tpm_input_header tpm2_pcrread_header = {
> > 
> > Missing const - all of these static structures in tpm2-cmds.c are missing
> > the const, please fix them all.
> > 
> > > +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> > > +	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
> > > +	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
> > > +};
> > 
> > BTW, I always thought this was a goofy and very expensive way to store
> > 3 values and zero initialize. If you want to do something different in
> > the tpm2-cmds.c that would be great too...
> 
> What do you think about the way trusted module builds messages? It's easier
> to maintain and debug than the approach used in the tpm subsystem.


Can you post an example (e.g. for the command stream above)

Peter
