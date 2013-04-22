Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3DVP5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:57:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55520 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab3DVP5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:57:24 -0400
From: "Anna, Suman" <s-anna@ti.com>
To: Jassi Brar <jassisinghbrar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Andy Green (andy.green@linaro.org)" <andy.green@linaro.org>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>
Subject: RE: [PATCHv3 00/14] drivers: mailbox: framework creation
Thread-Topic: [PATCHv3 00/14] drivers: mailbox: framework creation
Thread-Index: AQHOH5rZWZRuXv3gBEiVoUiWll2GeJjgh+uAgAIOGwA=
Date: Mon, 22 Apr 2013 15:56:57 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
 <CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
In-Reply-To: <CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3MFvVOX006864

> 
> Hi Suman,
> 
>   [Resending with mailing-list CCed this time. For some reason LKML doesn't
> appear in reply-to despite this message being fwd'ed from there]
> 
> On Wed, Mar 13, 2013 at 8:53 AM, Suman Anna <s-anna@ti.com> wrote:
> > Hi,
> > Please find the updated mailbox patch series for pulling into linux-next.
> > The series is rebased on top of 3.9-rc2, and includes one new patch to
> > rename an existing mailbox.h added as part of the highbank cpufreq
> > support for 3.9 merge window [1].
> >
> I am to implement IPC protocol and client drivers on a platform that has a master
> processor having control over critical h/w resources, like clock and power
> management, to be used by the MPCore running linux. And there are 2 such IPC
> controllers - one for communication within the MPCore and another for between
> MPCore and the 'Master'.
> 
> I have a few concerns about this api as follows...

Thank Jassi for your comments. I am aware of some of the concerns, Andy Green had highlighted (a) & (b) as well previously, and I am actually working through the next set of patches to fix these. I will post them sometime next week. 

> 
> a) No documentation. Usually the header would have proper documentation of
> data structures and info for users of both side of the api.

I will fix the documentation portion for 3.10. I will also add a TODO as part of the documentation so that it highlights the gaps and work-items.

> 
> b) The api is not scalable. The assumption of just one IPC controller in the
> platform is hardcoded.

Yes, this is a major concern and I will be handling this in the upcoming patches . The current code was primarily based on moving the OMAP mailbox code and expanding it to support the ST DBX500 mailbox. As it is today, it doesn't scale to support multiple IP instances/controllers.

> 
> c) There seems to be no consistent design - mailbox_ops has 12 callback hooks.
> Some, save_ctx, restore_ctx, enable_irq, disable_irq are exported for no
> apparent reason (legacy of a legacy - OMAP), while other hooks are kept private
> to the api.
> I believe OMAP had valid reasons to make IPC clients save/restore context of the
> IPC controller, but I don't think that is the case in general. I2C client drivers don't
> save/restore context of I2C controller's, why should IPC's?  Similarly
> enable/disable_irq of the controller seem too intrusive for a client driver.

Yep, these are exported because of the OMAP legacy TIDSPBRIDGE stack, and should vanish with the addition of runtime_pm support.

> 
> mailbox_ops.mailbox_type_t makes no sense to me. At least not without
> documentation, though I doubt any amount of documentation could help it -
> mailbox.c doesn't even read the member. Btw, isn't every mailbox a
> MBOX_SHARED_MEM_TYPE? A part of data passed via FIFO/REG could point to
> location in shared memory that might have full command/payload for the
> message. Or did I get the meaning of MBOX_SHARED_MEM_TYPE wrong in the
> absence of documentation?

Yes, this needs to be removed, it is a carry-over from the OMAP mailbox code.

> 
> The api seems to worry too much about the low-level details of the IPC controller
> (save/restore context, enable/disable_irq and ack_irq), while it fails to provide a
> tight well-defined interface to client drivers.
> 
> There are also some code issues, which might come as replies to respective
> patches.

Thanks for the review of the patches. I will await your comments, and will address them as incremental patches. 

Regards
Suman
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
