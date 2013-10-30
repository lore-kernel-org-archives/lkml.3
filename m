Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab3J3RTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:19:46 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:44144 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab3J3RTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:19:43 -0400
X-AuditID: cbfec373-b7f6d6d00000330d-ed-52713fae3632
Date: Wed, 30 Oct 2013 15:19:36 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Aristeu Rozanski <arozansk@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org,
        tony.luck@intel.com, Doug Thompson <dougthompson@xmission.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/12] sb_edac: move PCI IDs to pci_ids.h
Message-id: <20131030151936.48ba7af5@samsung.com>
In-reply-to: <20131030164020.GF13290@pd.tnic>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
 <1383150426-24730-2-git-send-email-arozansk@redhat.com>
 <20131030164020.GF13290@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/hIN119oVBBq1HxCzaTvxms1jSlGHx
	ecM/Noury84yWVw41cBkcXnXHDaLs/OOs1m8uXCPxYHD43trH4vHgk2lHov3vGTyeL/vKpvH
	501yHlMOtbMEsEVx2aSk5mSWpRbp2yVwZZw89Yyt4CR3xbSdT5kbGCdydjFycEgImEjcexvY
	xcgJZIpJXLi3nq2LkYtDSGAJo8TmtheMEE43k8Ta3kksIFUsAqoSZ4/uYQax2QSMJF41trCC
	2CICWhK3TqxlBmlgFuhikjj+4AkbSEJYwFbixsdP7CA2r4ChxMNzi8CaOQV0JbZdes4OsWEB
	o0Rbx04WiJOcJHYfkIKoF5T4Mfke2GJmoAWbtzWxQtjyEpvXvGWewCgwC0nZLCRls5CULWBk
	XsUoWlqcXFCclJ5rpFecmFtcmpeul5yfu4kREvbFOxhfbLA6xCjAwajEw8ugWxgkxJpYVlyZ
	e4hRgoNZSYRXzxgoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTFLXWXT/xc/jtWsc+es8l99ehf/
	LGlm7jj+2mUdzltvTGIPeKf+oUjL95h16z9lbpV/bUFNFjqrxFo8p/T0Cm9Isv0c0/3oD4fB
	x828J4p+T2feP3fe6fSODw//7L3qfTOnU8vo06qUOfKSXJ0bV0yvK3a5/sf+0ySxR9l54bNv
	MglPTV2+KVyJpTgj0VCLuag4EQAtbFKoWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 30 Oct 2013 17:40:20 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Wed, Oct 30, 2013 at 12:26:55PM -0400, Aristeu Rozanski wrote:
> > According to the comment, it should be done before submitting upstream.
> > 
> > Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
> > ---
> >  drivers/edac/sb_edac.c  |   21 ++-------------------
> >  include/linux/pci_ids.h |   11 +++++++++++
> >  2 files changed, 13 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> > index e04462b..4cdd948 100644
> > --- a/drivers/edac/sb_edac.c
> > +++ b/drivers/edac/sb_edac.c
> > @@ -57,26 +57,9 @@ static int probed;
> >   */
> >  
> >  /*
> > - * FIXME: For now, let's order by device function, as it makes
> > - * easier for driver's development process. This table should be
> > - * moved to pci_id.h when submitted upstream
> 
> Why, is anything else besides sb_edac.c using those?
> 
I think that this patch makes sense, as the other Sandy Bridge registers
are at pci_ids.h. So, it is a matter of consistency.

Also, I won't doubt that other drivers could need to access those, as
there are other things there on a few of those PCI IDs.

Yet, on patch 12/12, you're adding the Ivy Bridge specific PCI IDs
inside the driver.

So, IMHO, you should either move all to pci_ids.h or to keep them inside
the driver.

My personal taste would be to move them all to pci_ids.h.

Regards,
Mauro
