Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3LDRUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:20:46 -0500
Received: from smtprelay0128.hostedemail.com ([216.40.44.128]:52120 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932708Ab3LDRUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:20:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:2890:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4042:4250:4321:5007:6119:7652:8531:9040:10004:10400:10450:10455:10848:10967:11026:11232:11658:11914:12296:12438:12517:12519:12663:12740:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wren99_5d85630732e09
X-Filterd-Recvd-Size: 3600
Message-ID: <1386177641.30493.77.camel@joe-AO722>
Subject: Re: [PATCH 1/3] Introduce FW_INFO* functions and messages
From: Joe Perches <joe@perches.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 04 Dec 2013 09:20:41 -0800
In-Reply-To: <529F174D.3030805@redhat.com>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>
	 <1385997579-22240-2-git-send-email-prarit@redhat.com>
	 <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
	 <529F174D.3030805@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 06:51 -0500, Prarit Bhargava wrote:
> 
> On 12/03/2013 04:21 PM, Andrew Morton wrote:
> > On Mon,  2 Dec 2013 10:19:37 -0500 Prarit Bhargava <prarit@redhat.com> wrote:
> > A slight simplification:
> > 
> >> +static inline char *dump_hadware_arch_desc(void)
> >> +{
> >> +	return NULL;
> >> +}
> > 
> > 	return "unavailable";
> > 
> >> +void warn_slowpath_fmt_dev(const char *file, int line,
> >> +			   struct device *dev, int level, const char *fmt, ...)
> >> +{
> >> +	struct slowpath_args args;
> >> +	static char fw_str[16] = "\0";
> >> +
> >> +	switch (level) {
> >> +	case 1:
> >> +		strcpy(fw_str, "[Firmware Info]");
> >> +		break;
> >> +	case 2:
> >> +		strcpy(fw_str, "[Firmware Warn]");
> >> +		break;
> >> +	case 3:
> >> +		strcpy(fw_str, "[Firmware Bug]");
> > 
> > What's With The Crazy Capitalization In This Code?  It's Illiterate!
> 
> Heh :) it's what the original FW_* strings were defined as.  I was hoping it was
> okay to change them but wasn't 100% sure if I should.  I'll definitely take that
> (and the suggestion above) into v2.
> 
> <snip>
> 
> > 
> > The general thrust of the patchset seems useful and important.  I do
> > agree with Joe's suggestion regarding the presentation, although it
> > isn't a show-stopper.
> 
> In V2, I'll take Joe's suggestion into account.  It isn't that difficult to
> rework those chunks of the patch into a single patch.
> 
> > 
> > I do wonder if it all should be generalised a bit - it creates a bunch
> > of infrastructure which is specific to system firmware issues, but
> > what's so special about firmware?  Why can't I use this infrastructure
> > to log netdev errors or acpi errors or PM errors or...?  But I didn't
> > think about it much ;)
> 
> Well ... I was thinking about this.  Some drivers do keep track of firmware
> versions for their devices and I think there is probably a way to unify all that.

Isn't that simply using the generic #define FW_<type>s?

> Also, I think after this initial change goes in I'm going to grep through the
> PCI & ACPI code to see what FW_* changes need to be made there.  AFAICT there
> are many locations in those areas which should be FW_*.
> 
> I'll get a [v2] out in a little while.  Thanks Joe & Andrew for looking.

I think you should not remove the current #defines.
You can just leave them alone.  Add the new facility
without removing the old capability and then as the
utility of your new system is proven, then the old uses
can be converted if appropriate.


