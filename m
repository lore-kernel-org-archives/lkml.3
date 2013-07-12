Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab3GLP5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:57:44 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25614 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab3GLP5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:57:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ns9ZAko+gJtFRxe0JNwu9pJZqxRNsvoc=
Date: Fri, 12 Jul 2013 11:57:33 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Daniel Drake <dsd@laptop.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Bergmann Arnd <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Neil Zhang <zhangwm@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Message-ID: <20130712155733.GZ11908@titan.lakedaemon.net>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
 <1373352166-10064-2-git-send-email-zhangwm@marvell.com>
 <20130709124900.GG11908@titan.lakedaemon.net>
 <CAN1soZxiOh6TpbUOCUzK8gNwmvjbT3ihkUWaw8tuZ7md+NVA2g@mail.gmail.com>
 <20130710122433.GO11908@titan.lakedaemon.net>
 <CAN1soZzMvront1-jcBW6-uRKNs0OZNGnmiOjKGZSM28bViB_8A@mail.gmail.com>
 <20130710215041.GR11908@titan.lakedaemon.net>
 <CAN1soZzuiukY9qASFNcH0k=zH8=uT=71bKejPss44FCzNy=X-A@mail.gmail.com>
 <CAMLZHHQGZvDssY-YxQ3ZW8FYhpG-H1-VbokOid33socRSPrMNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHQGZvDssY-YxQ3ZW8FYhpG-H1-VbokOid33socRSPrMNw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 09:10:49AM -0600, Daniel Drake wrote:
> On Thu, Jul 11, 2013 at 5:54 PM, Haojian Zhuang
> <haojian.zhuang@gmail.com> wrote:
> >> Well, Daniel Drake spoke up for OLPC.  Does that count?
> >
> > We don't know they used DT on Marvell MMP2/MMP3. So they don't have DTS file
> > in kernel, we could use both old name & new name in driver.
> 
> You are listed as one of the MMP maintainers in the MAINTAINERS file
> and I have sent you several patches in the few 3 weeks which make
> OLPC's usage of MMP + DT pretty obvious. As a maintainer I believe you
> are supposed to review the patches too. hint hint ;)
> 
> My request to avoid breaking compatibility actually comes as a
> two-prong request.
> 
> I would prefer to see these compatible properties stay the same as it
> seems like changing them has little purpose/benefit - and there *will*
> become a later point where changing them causes major breakage.

I agree with both of you :)  It needs to stabilise quickly, but since
the first inception of Marvell compatible strings was in the mv643xx_eth
driver for powerpc (long before ARM thought it was cool), and they used
"marvell,...", I think we should stick with that.

Which means doing as Haojian now realizes, and having both strings in
the relevant drivers.

This also means we should do a patch for stable v3.5+ appending the
"mrvl,..." string to the drivers that had it removed improperly, as
Daniel discovered.  Daniel, since you are probably most familiar (and
most able to test ;-) ), would you mind putting that patch together?

So we don't have to keep it around forever, we could do as Arnd has
suggested in the past (for an entirely different problem):

	/* assuming it goes in for v3.12 */
	if (WARN_ON(of_device_is_compatible(dev, "mrvl,..."))) {
		dev_info(&dev->dev, "compatible string \"mrvl,...\" being removed in v3.15\n");
		BUG_ON(LINUX_VERSION_CODE >= KERNEL_VERSION(3,15,0));
	}

* I can't find where Arnd's suggestion was, so this hack is completely
my own.

Keep in mind, the above hack is just a suggestion, it makes my skin
crawl just looking at it... I'm open to other ideas.  Or, not doing it
at all.

thx,

Jason.
