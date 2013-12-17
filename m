Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3LQKq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:46:28 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:65005 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3LQKq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:46:26 -0500
Date: Tue, 17 Dec 2013 10:46:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Angus Clark <angus.clark@st.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 11/36] mtd: st_spi_fsm: Search for preferred FSM
 message sequence configurations
Message-ID: <20131217104617.GE19810@lee--X1>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-12-git-send-email-lee.jones@linaro.org>
 <20131211010636.GH27149@ld-irv-0074.broadcom.com>
 <52B01FF2.8010801@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52B01FF2.8010801@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +/* Search for preferred configuration based on available flags */
> >> +static struct seq_rw_config *
> >> +stfsm_search_seq_rw_configs(struct stfsm *fsm,
> >> +			    struct seq_rw_config cfgs[])
> >> +{
> >> +	struct seq_rw_config *config;
> >> +	int flags = fsm->info->flags;
> >> +
> >> +	for (config = cfgs; cfgs->cmd != 0; config++)
> > 
> > This becomes an infinite loop if you can't find a matching config. You
> > probably meant 'config->cmd != 0':
> 
> I will leave Lee to defend himself on this one ;-)

No defence necessary, I think Brian's correct.

NB: You might want to take a look at the 'dirty' implementation too. ;)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
