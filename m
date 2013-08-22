Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3HVCZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:25:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56561 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752242Ab3HVCZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:25:05 -0400
Message-ID: <1377138303.12003.25.camel@joe-AO722>
Subject: Re: [PATCH] scsi: fix the build warning
From: Joe Perches <joe@perches.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, akinobu.mita@gmail.com
Date: Wed, 21 Aug 2013 19:25:03 -0700
In-Reply-To: <CAEH94LgyGt=WZ=6oP1vgx826ULO_f_p89PMMzYiRq5Uf9gycQA@mail.gmail.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	 <1377133329.12003.9.camel@joe-AO722>
	 <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	 <1377134271.12003.15.camel@joe-AO722> <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
	 <1377136559.12003.18.camel@joe-AO722>
	 <CAEH94LgyGt=WZ=6oP1vgx826ULO_f_p89PMMzYiRq5Uf9gycQA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 09:59 +0800, Zhi Yong Wu wrote:
> On Thu, Aug 22, 2013 at 9:55 AM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2013-08-21 at 21:25 -0400, Martin K. Petersen wrote:
> >> >>>>> "Joe" == Joe Perches <joe@perches.com> writes:
> >>
> >> Joe> I don't get this build warning in the first place and I think the
> >> Joe> scsi_debug file is quite old and probably doesn't need to be
> >> Joe> changed at all.
> >>
> >> guard isn't a boolean, it selects the checksum algorithm used.
> >
> > OK, maybe this then...
> > ---
> >  drivers/scsi/scsi_debug.c | 2 +-
> >  1 file changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index cb4fefa..6fc2831 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -3312,7 +3312,7 @@ static int __init scsi_debug_init(void)
> >                 return -EINVAL;
> >         }
> >
> > -       if (scsi_debug_guard > 1) {
> > +       if (scsi_debug_guard < 0 || scsi_debug_guard > 1) {
> I don't think that it can fix that issue.

No, it doesn't fix any compile warning.  Your patch, if
it's needed, would still apply.

This patch suggestion fixes an issue where debug_guard
could be set to a negative value.

I didn't sign it, it's up to Martin or I suppose James
to actually want it done.

cheers, Joe

