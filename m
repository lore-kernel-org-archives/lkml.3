Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbaGYJCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:02:13 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:55017 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312AbaGYJCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:02:10 -0400
Date: Fri, 25 Jul 2014 02:02:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sachin Kamat <spk.linux@gmail.com>
cc: pramod.gurav.etc@gmail.com, linux-input@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lejun Zhu <lejun.zhu@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH] Input: soc_button_array: Remove kfree on data allocated
 with devm_zalloc
In-Reply-To: <CAK5sBcFMxKzB8KgSDTtfsGV173TV6Ji3VFNETVqgpGeHPS7LEg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1407250155450.17833@chino.kir.corp.google.com>
References: <1406272180-25101-1-git-send-email-pramod.gurav@smartplayin.com> <CAK5sBcFMxKzB8KgSDTtfsGV173TV6Ji3VFNETVqgpGeHPS7LEg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Sachin Kamat wrote:

> On Fri, Jul 25, 2014 at 12:39 PM,  <pramod.gurav.etc@gmail.com> wrote:
> > From: Pramod Gurav <pramod.gurav@smartplayin.com>
> >
> > This patch does below:
> > - Removes kfree done on data allocated with devm_zalloc in probe
> >   path of the driver.
> > - Adds a check on return value from devm_kzalloc which was missing
> >   and renames a lable from err_free_mem to err_mem.
> > - Adds couple of dev_err on failure to allocate memory
> >
> > CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > CC: Lejun Zhu <lejun.zhu@linux.intel.com>
> > CC: Sachin Kamat <sachin.kamat@linaro.org>
> >
> > Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> > ---
> >  drivers/input/misc/soc_button_array.c |   19 ++++++++++++++-----
> >  1 file changed, 14 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
> > index 5a6334b..ac82971 100644
> > --- a/drivers/input/misc/soc_button_array.c
> > +++ b/drivers/input/misc/soc_button_array.c
> > @@ -83,6 +83,13 @@ soc_button_device_create(struct pnp_dev *pdev,
> >                                        sizeof(*gpio_keys_pdata) +
> >                                         sizeof(*gpio_keys) * MAX_NBUTTONS,
> >                                        GFP_KERNEL);
> > +       if (!gpio_keys_pdata) {
> > +               dev_err(&pdev->dev,
> > +                       "Can't allocate memory for gpio_keys_platform_data\n");
> 
> OOM message is not needed as memory subsystem will take care of it.
> 

In the worst case, the memory subsystem will print that a process was 
killed for this allocation to succeed so it's never actually going to 
fail.  However, it is indeed frowed upon to print your own oom message so 
you're right that it should be removed.

Same comment about soc_button_pnp_probe().
