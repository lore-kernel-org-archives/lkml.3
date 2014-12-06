Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaLFWkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 17:40:53 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52043 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaLFWkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 17:40:52 -0500
Date: Sat, 6 Dec 2014 14:41:17 -0800
From: Tristan Lelong <tristan@lelong.xyz>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: "Drokin, Oleg" <oleg.drokin@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "standby24x7@gmail.com" <standby24x7@gmail.com>,
        "askb23@gmail.com" <askb23@gmail.com>,
        "Hammond, John" <john.hammond@intel.com>,
        "bergwolf@gmail.com" <bergwolf@gmail.com>,
        "Wang, Di" <di.wang@intel.com>,
        "Pershin, Mike" <mike.pershin@intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: lustre: replace static value with define
Message-ID: <20141206224117.GB17675@dunderer>
References: <1417850172-17092-1-git-send-email-tristan@lelong.xyz>
 <D0A88610.CE1D7%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D0A88610.CE1D7%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 05:09:29PM +0000, Dilger, Andreas wrote:
> > 
> >diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c
> >b/drivers/staging/lustre/lustre/fld/lproc_fld.c
> >index 74b4db9..7a55941 100644
> >--- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
> >+++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
> >@@ -96,7 +96,7 @@ fld_proc_hash_seq_write(struct file *file,
> > 	char *name;
> > 	int i;
> > 
> >-	if (count > 80)
> >+	if (count > LUSTRE_MDT_MAXNAMELEN)
> > 		return -ENAMETOOLONG;
> 
> Sorry for the late reply, but this has nothing to do with an MDT service
> name, so using this #define is misleading here.  As I wrote in my other
> email, this only needs to be at most 8 characters.
> 

I see that now, I will change that according to the other email.

Do you want me to redo this patch and still define the 80 as LUSTRE_MDT_MAXNAMELEN
but without this last part (just the define and the string length declaration), or
should we just let this go?

Thanks
