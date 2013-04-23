Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab3DWRwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:52:41 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5014 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3DWRwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:52:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Apr 2013 10:50:25 -0700
From: Bibek Basu <bbasu@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pritesh Raithatha <praithatha@nvidia.com>
Date: Tue, 23 Apr 2013 23:22:33 +0530
Subject: RE: [PATCH] pinctrl: tegra: add suspend-resume support
Thread-Topic: [PATCH] pinctrl: tegra: add suspend-resume support
Thread-Index: Ac4wh1jykOuKG9aYTleYyO58mFCMsAPw7tng
Message-ID: <77F7DB30C698A44DA22FB222C89DE941A6692E5D7D@BGMAIL01.nvidia.com>
References: <1364490685-21831-1-git-send-email-bbasu@nvidia.com>
 <CACRpkdbnHd+HVedHzQZ8-QO8VJE-Wx+0EazYb2mh9uJHi4OfVw@mail.gmail.com>
In-Reply-To: <CACRpkdbnHd+HVedHzQZ8-QO8VJE-Wx+0EazYb2mh9uJHi4OfVw@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/04/2013 11:25 PM, Bibek Basu wrote:
> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: Wednesday, April 03, 2013 9:52 PM
> To: Bibek Basu
> Cc: linux-kernel@vger.kernel.org; Pritesh Raithatha
> Subject: Re: [PATCH] pinctrl: tegra: add suspend-resume support
> 
> On Thu, Mar 28, 2013 at 6:11 PM, Bibek Basu <bbasu@nvidia.com> wrote:
> 
> Hm I recognize this name :-)
> 
You recognized me correctly. After all it's a small world:-)
> > This patch adds suspend and resume callbacks to the pinctrl-tegra driver.
> 
> Please be more verbose. How is this achieved? I have to guess what the code
> is doing..
> 
> > +#ifdef CONFIG_PM_SLEEP
> > +
> > +static int pinctrl_suspend(void)
> > +{
> > +       int i, j;
> > +       u32 *pg_data = pmx->pg_data;
> > +       u32 *regs;
> > +
> > +       for (i = 0; i < pmx->nbanks; i++) {
> > +               regs = pmx->regs[i];
> > +               for (j = 0; j < pmx->regs_size[i] / 4; j++)
> > +                       *pg_data++ = readl(regs++);
> > +       }
> > +       return 0;
> > +}
> > +
> > +static void pinctrl_resume(void)
> > +{
> > +       int i, j;
> > +       u32 *pg_data = pmx->pg_data;
> > +       u32 *regs;
> > +
> > +       for (i = 0; i < pmx->nbanks; i++) {
> > +               regs = pmx->regs[i];
> > +               for (j = 0; j < pmx->regs_size[i] / 4; j++)
> > +                       writel(*pg_data++, regs++);
> > +       }
> > +}
> > +
> > +static struct syscore_ops pinctrl_syscore_ops = {
> > +       .suspend = pinctrl_suspend,
> > +       .resume = pinctrl_resume,
> > +};
> > +
> > +#endif
> (...)
> > +#ifdef CONFIG_PM_SLEEP
> > +       register_syscore_ops(&pinctrl_syscore_ops);
> > +#endif
> 
> So Stephen already commented that syscore ops is maybe too big a
> sledgehammer for a fine-granular problem.
> 
> I mainly want to know what is happening above, it looks like a state
> save/restore for all registers or something like this?
> 
Yeah, patch mainly saves and restores the registers.
I am re-pushing the patch after incorporating stephen's changes.

regards
Bibek
> Yours,
> Linus Walleij
