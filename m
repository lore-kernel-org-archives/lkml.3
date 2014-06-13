Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaFMRhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:37:25 -0400
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:48796 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753246AbaFMRhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:37:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:152:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2691:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:5007:6119:7514:7652:7903:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13255:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: eggs43_60e45f46cb07
X-Filterd-Recvd-Size: 2166
Message-ID: <1402681040.3509.11.camel@joe-AO725>
Subject: Re: [PATCH] staging: wlan-ng: fix Missing a blank line after
 declarations warnings
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Cheng-Wei Lee <lee.rhapsody@gmail.com>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Jun 2014 10:37:20 -0700
In-Reply-To: <20140613171526.GA19285@kroah.com>
References: <CAJKoSVTafxWR3eLO=tLv1VSrdyuAp_-eEJWCGBJ+zTRqcp=VVw@mail.gmail.com>
	 <20140613171526.GA19285@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 10:15 -0700, Greg Kroah-Hartman wrote:
> On Fri, Jun 13, 2014 at 10:58:14PM +0800, Cheng-Wei Lee wrote:
> > Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
[]
> > diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
[]
> > @@ -3533,7 +3533,6 @@ static void hfa384x_usbin_rx(wlandevice_t
> > *wlandev, struct sk_buff *skb)
> >  	}
> > 
> >  done:
> > -	return;
> >  }
> 
> That's a good thing to do, but it is not what you said you did up above
> in the changelog entry.

I don't believe it's a good thing to do at all.
I suspect more that this wasn't compile tested.

This doesn't compile for at least several
supported gcc versions. 

gcc doesn't (didn't? I haven't tried 4.9) like:

label:
}

to terminate a function definition.

$ cat label_test.c
void func(void)
{
	goto label;
label:
}
$

with gcc 4.8:

$ gcc label_test.c
label_test.c: In function ‘func’:
label_test.c:5:1: error: label at end of compound statement
 label:
 ^

whereas this compiles fine:

$ cat label_test2.c
void func(void)
{
	goto label;
label:
	;
}
$

