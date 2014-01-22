Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaAVCBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:01:55 -0500
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:41701 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753338AbaAVCBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:01:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:7514:7652:8957:9025:9388:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12731:12737:12740:12933:13870:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: van90_103806211774e
X-Filterd-Recvd-Size: 3411
Message-ID: <1390356108.31946.20.camel@joe-AO722>
Subject: Re: staging: vt6656: device.h Remove typedef enum
 __device_init_type.
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tvboxspy@gmail.com
Date: Tue, 21 Jan 2014 18:01:48 -0800
In-Reply-To: <20140122015753.GA20560@kroah.com>
References: <20140121002130.38BFD660F3F@gitolite.kernel.org>
	 <20140121151643.GA19358@redhat.com> <20140122015753.GA20560@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-21 at 17:57 -0800, Greg KH wrote:
> On Tue, Jan 21, 2014 at 10:16:43AM -0500, Dave Jones wrote:
> > On Tue, Jan 21, 2014 at 12:21:30AM +0000, Linux Kernel wrote:
> >  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=302433daf47aeb7d21d66e55fb84d6a8fffd4aed
> >  > Commit:     302433daf47aeb7d21d66e55fb84d6a8fffd4aed
> >  > Parent:     a72f8beeedc97b776799a1a80c04eb5312980c9b
> >  > Author:     Malcolm Priestley <tvboxspy@gmail.com>
> >  > AuthorDate: Sun Nov 3 17:40:51 2013 +0000
> >  > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >  > CommitDate: Mon Nov 11 16:31:00 2013 -0800
> >  > 
> >  >     staging: vt6656: device.h Remove typedef enum __device_init_type.
> >  >     
> >  >     Since typedef enum __device_init_type is only ever called
> >  >     in one state.
> >  >     
> >  >     Remove the typedef from main_usb.c:device_init_registers and
> >  >     replace with macro values. The other values may be needed later.
> >  >     
> >  >     Apply cold value to sInitCmd.byInitClass.
> >  >     
> >  >     Remove if braces and correct formatting within.
> > 
> >  ...
> > 
> >  >  	/* load power table */
> >  >  	for (ii = 0; ii < 14; ii++) {
> >  > -            pDevice->abyCCKPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
> >  > -            if (pDevice->abyCCKPwrTbl[ii] == 0)
> >  > -                pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
> >  > -            pDevice->abyOFDMPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
> >  > -            if (pDevice->abyOFDMPwrTbl[ii] == 0)
> >  > -                pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
> >  > -        }
> >  > +		pDevice->abyCCKPwrTbl[ii] =
> >  > +			pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
> >  > +
> >  > +		if (pDevice->abyCCKPwrTbl[ii] == 0)
> >  > +			pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
> >  > +			pDevice->abyOFDMPwrTbl[ii] =
> >  > +				pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
> >  > +		if (pDevice->abyOFDMPwrTbl[ii] == 0)
> >  > +			pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
> >  > +	}
> > 
> > Wrong indentation of the pDevice->abyOFDMPwrTbl[ii] assignment.
> > Wrapping this to 80 columns has actually made this less readable imo.
> 
> Good catch, I'll fix that up after 3.14-rc1 is out, thanks for finding
> it.

It'd also be nice to eventually do away with the
semi-Hungarian notation aby, p, by, etc prefixes
and camelcase naming.

