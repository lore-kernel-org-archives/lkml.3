Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaLTDv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 22:51:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbaLTDv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 22:51:57 -0500
Date: Fri, 19 Dec 2014 22:51:48 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, sgrubb@redhat.com, eparis@parisplace.org,
        pmoore@redhat.com
Subject: Re: [PATCH] audit: use supplied gfp_mask from audit_buffer in
 kauditd_send_multicast_skb
Message-ID: <20141220035148.GA512@madcap2.tricolour.ca>
References: <d261c547d8018a18f2092e1907b06e190162b088.1418947557.git.rgb@redhat.com>
 <74385.1419036779@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74385.1419036779@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/19, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 18 Dec 2014 23:09:27 -0500, Richard Guy Briggs said:
> > Eric Paris explains: Since kauditd_send_multicast_skb() gets called in
> > audit_log_end(), which can come from any context (aka even a sleeping context)
> > GFP_KERNEL can't be used.  Since the audit_buffer knows what context it should
> > use, pass that down and use that.
> >
> > See: https://lkml.org/lkml/2014/12/16/542
> 
> > Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 7b83c55..ce484fb 100644
> 
> I was reliably triggering 3-4 BUGs an hour, and with this patch applied I've
> gone 9 hours without seeing one.
> 
> So feel free to add a Tested-By:  when it goes out.

Good stuff.  Thanks for testing this Valdis!

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
