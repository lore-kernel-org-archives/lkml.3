Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaD1HT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 03:19:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51912 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaD1HT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 03:19:27 -0400
Message-ID: <1398669512.5214.11.camel@iivanov-dev>
Subject: Re: [PATCH v7 05/20] usb: phy: msm: Migrate to Managed Device
 Resource allocation
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: Fabio Estevam <festevam@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Date: Mon, 28 Apr 2014 10:18:32 +0300
In-Reply-To: <20140425205331.GM29632@saruman.home>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
	 <1398354495-20782-6-git-send-email-iivanov@mm-sol.com>
	 <CAOMZO5COKimLjC0oYqgwSaEvSBUpoy9aP_P-ScU+ozh0KpsCoA@mail.gmail.com>
	 <20140425205331.GM29632@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 15:53 -0500, Felipe Balbi wrote:
> On Thu, Apr 24, 2014 at 01:49:38PM -0300, Fabio Estevam wrote:
> > On Thu, Apr 24, 2014 at 12:48 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> > 
> > > +       motg->vddcx = devm_regulator_get(motg->phy.dev, "HSUSB_VDDCX");
> > > +       if (IS_ERR(motg->vddcx)) {
> > > +               dev_err(motg->phy.dev, "unable to get hsusb vddcx\n");
> > > +               return PTR_ERR(motg->vddcx);
> > > +       }
> > > +
> > > +       motg->v3p3 = devm_regulator_get(motg->phy.dev, "HSUSB_3p3");
> > > +       if (IS_ERR(motg->v3p3)) {
> > > +               dev_err(motg->phy.dev, "unable to get hsusb 3p3\n");
> > > +               return PTR_ERR(motg->v3p3);
> > > +       }
> > > +
> > > +       motg->v1p8 = devm_regulator_get(motg->phy.dev, "HSUSB_1p8");
> > > +       if (IS_ERR(motg->v1p8)) {
> > > +               dev_err(motg->phy.dev, "unable to get hsusb 1p8\n");
> > > +               return PTR_ERR(motg->v1p8);
> > > +       }
> > 
> > It seems that calling devm_regulator_bulk_get() here would simplify
> > the code here.

Sure. 

> 
> any comments here ?? Should I expect a new version ?


Will fix rest of the comments and send updated patch set.

Regards,
Ivan
> 


