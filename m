Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaHCA1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 20:27:51 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:44237 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750866AbaHCA1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 20:27:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1256:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:3874:4321:4605:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stone31_6136c7e93dd34
X-Filterd-Recvd-Size: 2232
Message-ID: <1407025666.1835.16.camel@joe-AO725>
Subject: Re: [PATCH] fs: cifs: cifsencrypt.c: Cleaning up missing
 null-terminate in conjunction with strncpy
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 02 Aug 2014 17:27:46 -0700
In-Reply-To: <CAFo99gZrTd5+Z_XK+CmhF8ROPZSLGZvwzuwQSwFz5_kGHTAn8w@mail.gmail.com>
References: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <CADT32eLts-tdQdHo+W3Zc1wQ6Qz8aS3TmHsm8OxmiF2fmhOW5g@mail.gmail.com>
	 <1407000807.1835.14.camel@joe-AO725>
	 <CAFo99gZrTd5+Z_XK+CmhF8ROPZSLGZvwzuwQSwFz5_kGHTAn8w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-08-03 at 01:13 +0200, Rickard Strandqvist wrote:
> 2014-08-02 19:33 GMT+02:00 Joe Perches <joe@perches.com>:
> > On Sat, 2014-08-02 at 11:55 -0500, Shirish Pargaonkar wrote:
> >> Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>
> > []
> >> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > []
> >> > @@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
> >> >
> >> >         memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
> >> >         if (password)
> >> > -               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
> >> > +               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);
> >
> >
> > Is this always correct?
[]
> Because password_with_pad gets set to all zeros above, the character,
> I do not guarantee a copy terminating null.
> Unless it is so that you do not want any terminating null.

That's the question for Steve and cifs people.

