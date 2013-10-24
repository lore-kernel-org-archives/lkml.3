Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3JXQYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:24:19 -0400
Received: from mail.abilis.ch ([195.70.19.74]:28704 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab3JXQYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:24:17 -0400
Date: Thu, 24 Oct 2013 18:23:47 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/03] GPIO: Add TB10x GPIO driver
Message-ID: <20131024162346.GA3769@ab42.lan>
References: <20131008122145.GA21985@ab42.lan>
 <1381235122-23730-3-git-send-email-christian.ruppert@abilis.com>
 <CACRpkdaMq1bzcTP6KZCGuWSm2MB0vSmJ4aRskuQNB8at4YnWRQ@mail.gmail.com>
 <20131015134526.GB7461@ab42.lan>
 <CACRpkdZjfNJtAsbge+HsWZQjNREnJQ7msyPy9g3cMLtc8KhmPg@mail.gmail.com>
 <20131016125855.GA20308@ab42.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016125855.GA20308@ab42.lan>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 02:58:55PM +0200, Christian Ruppert wrote:
> On Wed, Oct 16, 2013 at 01:29:44PM +0200, Linus Walleij wrote:
> > On Tue, Oct 15, 2013 at 3:45 PM, Christian Ruppert
> > <christian.ruppert@abilis.com> wrote:
> > > On Wed, Oct 09, 2013 at 02:19:17PM +0200, Linus Walleij wrote:
> > 
> > >> It's not like I'm 100% certain on where to use one or the other
> > >> construct (a mechanism like the above is needed for threaded
> > >> IRQs I've noticed) but the chained handler seems more to the
> > >> point does it not?
> > >>
> > >> The only downside I've seen is that the parent IRQ does not get
> > >> a name and the accumulated IRQ stats in /proc/interrupts but
> > >> surely we can live without that (or fix it).
> > >>
> > >> Since I'm a bit rusty on chained IRQs correct me if I'm wrong...
> > >
> > > OK, it took me a while to figure this back out again because as far as
> > > I'm familiar with the IRQ framework you're right. The reason I'm not
> > > using irq_set_chained_handler is that we have one driver instance per
> > > GPIO bank and all GPIO banks share the same interrupt line. This means
> > > every driver instance needs its own (different) user data and a simple
> > > call to irq_set_handler_data(tb10x_gpio) won't suffice. I'm not aware of
> > > any mechanism that allows interrupt sharing with the
> > > irq_set_chained_handler() mechanism.
> > 
> > OK yes makes perfect sense. We'll live with this then.
> > 
> > I didn't see a new version of this patch with the other two, shall
> > I just apply this last version in the pin control tree with the
> > two other patches?
> 
> If you don't see anything else which needs changing please do so, yes.

Hi Linus,

I didn't see this one pop up in the git repositories yet, are there any
issues left with the driver?

Best regards,
  Christian
