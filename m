Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3KDSDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:03:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36850 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3KDSDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:03:01 -0500
Date: Mon, 4 Nov 2013 10:03:00 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        List Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 09/11] ARM: msm: Add SMP support for KPSSv2
Message-ID: <20131104180300.GM21983@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
 <1383343739-23080-10-git-send-email-sboyd@codeaurora.org>
 <CACqS6krDt=zDWNXKTu2PvCkMXQbbf-4G2RZtuCt1deU6H2SUxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqS6krDt=zDWNXKTu2PvCkMXQbbf-4G2RZtuCt1deU6H2SUxQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01, Janakiram Sistla wrote:
> On 1 November 2013 15:08, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > +               err = -ENOMEM;
> > +               goto err_map;
> > +       }
> > +
> > +       l2_saw_base = of_iomap(l2_node, 0);
> > +       if (!l2_saw_base) {
> > +               err = -ENOMEM;
> > +               goto err_l2_map;
> > +       }
> > +
> > +       /* Turn on the BHS, turn off LDO Bypass and power down LDO */
> > +       reg_val =  0x403f0001;
> >
> I think patch looks more nice if this hard coding is defined in terms of
> macros
> 
> > +       writel_relaxed(reg_val, reg + APC_PWR_GATE_CTL);
> > +
> > +       /* complete the above write before the delay */
> > +       mb();
> > +       /* wait for the bhs to settle */
> > +       udelay(1);
> > +
> > +       /* Turn on BHS segments */
> > +       reg_val |= 0x3f << 1;
> >
> same as above
> 

Ok. I'll see what I can do.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
