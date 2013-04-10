Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936776Ab3DJPHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:07:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38920 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935753Ab3DJPHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:07:43 -0400
Message-ID: <1365606461.1942.3.camel@dabdike>
Subject: Re: checkpatch: kill the bogus camelcase check
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Wed, 10 Apr 2013 08:07:41 -0700
In-Reply-To: <20130410145213.GA6854@pd.tnic>
References: <1365544254.2946.53.camel@dabdike> <20130410132628.GV7511@dm>
	 <1365604558.27174.36.camel@joe-AO722> <20130410145213.GA6854@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 16:52 +0200, Borislav Petkov wrote:
> On Wed, Apr 10, 2013 at 07:35:58AM -0700, Joe Perches wrote:
> > or maybe exclude drivers/scsi and include/scsi/
> 
> and arch/x86/kvm/emulate.c

Actually, we get this all over drivers.  Some of the problems are to do
with the fact that the check is wrong, so it thinks things like this

drm_core_has_MTRR

are studly caps when they're not, but we have a lot of device
programming manual driven studly caps in PCI, ata, ide etc ..

We also have sanctioned use in mm, things like:

SetPageReserved
ClearPageReserved

But the point still stands.  When checkpatch warns about this, there's
nothing that the person submitting the patch can do because the usage
was already embedded into the file they're patching.

James


