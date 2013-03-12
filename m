Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3CLN0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:26:31 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:64771 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3CLN03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:26:29 -0400
Date: Tue, 12 Mar 2013 06:27:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Brown <davidb@codeaurora.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] platform-drivers: msm: add single-wire serial bus
 interface (SSBI) driver
Message-ID: <20130312132719.GA3421@kroah.com>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
 <1362616187-21089-2-git-send-email-davidb@codeaurora.org>
 <20130307013008.GA2910@kroah.com>
 <8yamwu9nmar.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8yamwu9nmar.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:51:08PM -0700, David Brown wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> >> +static int ssbi_wait_mask(struct msm_ssbi *ssbi, u32 set_mask, u32 clr_mask)
> >> +{
> >> +	u32 timeout = SSBI_TIMEOUT_US;
> >> +	u32 val;
> >> +
> >> +	while (timeout--) {
> >> +		val = ssbi_readl(ssbi, SSBI2_STATUS);
> >> +		if (((val & set_mask) == set_mask) && ((val & clr_mask) == 0))
> >> +			return 0;
> >> +		udelay(1);
> >
> > Busy loop?  Really?
> 
> Finally was able to dig up some of the reason for this.  The
> transactions typically take about 5us.  In the case of contention with
> another CPU, it could take as much as 20us.
> 
> Would it be sufficient to just explain this in a comment?

That would be good to do, especially if it turns out to be a longer
delay and people start to wonder why their system load is increasing for
no noticeable reason.

thanks,

greg k-h
