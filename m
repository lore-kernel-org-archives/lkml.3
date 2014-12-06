Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaLFWeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 17:34:09 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51139 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaLFWeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 17:34:07 -0500
Date: Sat, 6 Dec 2014 14:34:29 -0800
From: Tristan Lelong <tristan@lelong.xyz>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        "askb23@gmail.com" <askb23@gmail.com>,
        "Hammond, John" <john.hammond@intel.com>,
        "gdonald@gmail.com" <gdonald@gmail.com>,
        "anhlq2110@gmail.com" <anhlq2110@gmail.com>,
        "fabio.falzoi84@gmail.com" <fabio.falzoi84@gmail.com>,
        "oort10@gmail.com" <oort10@gmail.com>,
        "agimenez@sysvalve.es" <agimenez@sysvalve.es>,
        "rupran@einserver.de" <rupran@einserver.de>,
        "surya.seetharaman9@gmail.com" <surya.seetharaman9@gmail.com>,
        "Julia.Lawall@lip6.fr" <Julia.Lawall@lip6.fr>,
        "joe@perches.com" <joe@perches.com>,
        "a.terekhov@gmail.com" <a.terekhov@gmail.com>,
        "vthakkar1994@gmail.com" <vthakkar1994@gmail.com>,
        "amk@cray.com" <amk@cray.com>,
        "srikrishanmalik@gmail.com" <srikrishanmalik@gmail.com>,
        "rd@radekdostal.com" <rd@radekdostal.com>,
        "bergwolf@gmail.com" <bergwolf@gmail.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "Gortmaker, Paul (Wind River)" <paul.gortmaker@windriver.com>,
        "tapaswenipathak@gmail.com" <tapaswenipathak@gmail.com>,
        "email@christophjaeger.info" <email@christophjaeger.info>,
        "uja.ornl@gmail.com" <uja.ornl@gmail.com>,
        "brilliantov@inbox.ru" <brilliantov@inbox.ru>,
        "Eremin, Dmitry" <dmitry.eremin@intel.com>,
        "HPDD-discuss@lists.01.org" <HPDD-discuss@ml01.01.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS
 macros
Message-ID: <20141206223429.GA17675@dunderer>
References: <1417766627-5232-1-git-send-email-tristan@lelong.xyz>
 <20141205212723.GA22536@kroah.com>
 <20141205224143.GB5698@localhost.localdomain>
 <D0A87E89.CDFB9%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D0A87E89.CDFB9%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Sat, Dec 06, 2014 at 05:05:14PM +0000, Dilger, Andreas wrote:
> On 2014/12/05, 3:41 PM, "Tristan Lelong" <tristan@lelong.xyz> wrote:
> 
> 
> Sorry, but I don't see where you get 80 from?  fh_name is declared as a
> "const char *", and initialized in the declaration of fld_hash[].  I'd
> thought to reply that sizeof(fh_name) would even be better than a #define,
> but sizeof(const char *) doesn't actually make sense.
> 

You are right, I got confused with the names trying to follow the declaration of the variable.

> The longest declared fh_name is 4 characters, but I'm not sure of an easy
> way to determine this at compile time.  I guess one option is to change
> the declaration of struct lu_fld_hash to use "const char fh_name[4];" and
> then use sizeof(fh_name), but I don't know if that is better than just
> declaring a small buffer (8 chars) for this usage.  IMHO that is small
> enough to fit on the stack, since it is at the top of a very short
> callchain (userspace->sys_write->vfs_write->fld_proc_hash_seq_write())
> that just saves the value so the chance of stack overflow is basically nil.
> 

I can implement any of those 2 options. If somebody as a strong preference, let me know,
otherwise I'll follow Andreas idea and will redo the patch with a stack name variable of size 8.

> 
> Cheers, Andreas
> -- 
> Andreas Dilger
> 
> Lustre Software Architect
> Intel High Performance Data Division
> 
> 

Thanks for your comment and help.
