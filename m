Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbaLBHrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:47:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaLBHrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:47:47 -0500
Date: Tue, 25 Nov 2014 14:57:19 -0800
From: Darren Hart <dvhart@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Giedrius Statkevicius <giedriuswork@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH] platform: x86: hp_wireless: Inform the user if
 hp_wireless_input_setup()/add() fails
Message-ID: <20141125225719.GA32102@vmdeb7>
References: <1417212867-25187-1-git-send-email-giedriuswork@gmail.com>
 <20141128231555.GA31468@pd.tnic>
 <547909CF.8060907@gmail.com>
 <20141129000417.GG30997@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141129000417.GG30997@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 01:04:17AM +0100, Borislav Petkov wrote:
> On Sat, Nov 29, 2014 at 01:48:31AM +0200, Giedrius Statkevicius wrote:
> > On 2014.11.29 01:15, Borislav Petkov wrote:
> > > On Sat, Nov 29, 2014 at 12:14:27AM +0200, Giedrius Statkevicius wrote:
> > >> In hpwl_add() there is a unused variable err to which we assign the
> > >> result of hp_wireless_input_setup() but we don't do anything depending
> > >> on the result so print out a message that informs the user if add()
> > >> (hp_wireless_input_setup()) fails since acpi_device_probe() doesn't
> > >> print anything in this case.
> > >>
> > >> Signed-off-by: Giedrius Statkevicius <giedriuswork@gmail.com>
> > >> ---
> > >>  drivers/platform/x86/hp-wireless.c | 3 +++
> > >>  1 file changed, 3 insertions(+)
> > >>
> > >> diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
> > >> index 415348f..4e4cc8b 100644
> > >> --- a/drivers/platform/x86/hp-wireless.c
> > >> +++ b/drivers/platform/x86/hp-wireless.c
> > >> @@ -85,6 +85,9 @@ static int hpwl_add(struct acpi_device *device)
> > >>  	int err;
> > >>  
> > >>  	err = hp_wireless_input_setup();
> > >> +	if (err)
> > >> +		pr_err("Failed to setup hp wireless hotkeys\n");
> > >> +
> > > 
> > > I don't think there's need for that. Just do:
> > > 
> > > 	return hp_wireless_input_setup();
> > > 
> > > and drop err completely.
> > > 
> > > The upper layer which calls the ->add() method should propagate the
> > > error properly.

This is the key. If the caller already prints a message, we don't need to. If
nothing is displayed and the user would be left confused, then an appropriate
message should be displayed.

If the upper level already handles this, then we can just drop the unused
variable.

Have a look and decide which is the most appropriate. And thanks for preparing a
fix.

-- 
Darren Hart
Intel Open Source Technology Center
