Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbaLECmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:42:51 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933517AbaLECmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:42:50 -0500
Date: Wed, 3 Dec 2014 04:49:17 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH v2] platform: x86: dell-laptop: Add support for keyboard
 backlight
Message-ID: <20141203124916.GA75099@vmdeb7>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com>
 <1416754245-15550-1-git-send-email-pali.rohar@gmail.com>
 <20141203084319.GA52608@vmdeb7>
 <201412050303.49206@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412050303.49206@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 03:03:49AM +0100, Pali Rohár wrote:
> On Wednesday 03 December 2014 09:43:21 Darren Hart wrote:
> > On Sun, Nov 23, 2014 at 03:50:45PM +0100, Pali Rohár wrote:
> > > This patch adds support for configuring keyboard backlight
> > > settings on supported Dell laptops. It exports kernel leds
> > > interface and uses Dell SMBIOS tokens or keyboard class
> > > interface.
> > > 
> > > With this patch it is possible to set:
> > > * keyboard backlight level
> > > * timeout after which will be backlight automatically turned
> > > off * input activity triggers (keyboard, touchpad, mouse)
> > > which enable backlight * ambient light settings
> > > 
> > > Settings are exported via sysfs:
> > > /sys/class/leds/dell::kbd_backlight/
> > > 
> > > Code is based on newly released documentation by Dell in
> > > libsmbios project.
> > 
> > Hi Pali,
> > 
> > I would really like to see this broken up. Possibly adding
> > levels and timeouts as separate patches for example. It is
> > quite difficult to review this all at once in a reasonable
> > amount of time.
> > 
> 
> It is really hard to split this patch into more parts which every 
> one will compile and ideally also work. In my opinion every 
> single git commit should be possible to compile and should also 
> work (it helps also other developers to use git bisect).

Of course, that's a given.

> 
> And because we need to pass all (previous unchanged) values in 
> smbios call we need to parse all of them.
> 
> I understand that it could be hard to review long patch, but 
> there are more parts which interacts and do not work without 
> other. Also some of settings (e.g keyboard backlight level) could 
> be changed via different ways (and on some machines only one is 
> working) and also that smbios keyboard interface has complicated 
> logic...

I was thinking about how to break it up, and I don't have an obvious answer. I
considered adding a levels interface first and then the mode_levels, but that's
a lot of work for not much savings. I don't like adding over 1000 lines to a 900
line driver in a single go to add one feature, but I didn't see obvious ways to
a) make it smaller or b) break it up.

So, please incorporate the remaining requested changes, and I'll pull it in.

Patches should really be in next for two weeks before going to Linus for a
merge. As we're already at rc7, that makes 3.19 a stretch. Get it to me by
tomorrow and I'll queue it up.... but it might not make 3.19.

For future patches, please add some additional comments to code that is
non-obvious and if there is any way to break the patches up. This will expedite
the review process (as this subsystem gets fairly little external review, you
end up blocked on me).

> 
> > During this review I caught a few more CodingStyle violations,
> > and raised some questions about the timeout and levels
> > mechanisms.
> > 
> 
> I will fix style problems in next v3 patch.
>  
> What to do with Dan Carpenter patch which fixing kbd_timeout 
> handling? Should I integrate it into v3? It does not apply on top 
> of next v3 patch, because there will be new comment about quirk 
> plus style fixes...

Please include Dan's fix and credit him with it in the commit message. Add him
to the Cc list.

Thanks Pali,

-- 
Darren Hart
Intel Open Source Technology Center
