Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3CLGvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:51:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10126 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab3CLGvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:51:09 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355126400"; 
   d="scan'208";a="28671960"
From: David Brown <davidb@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] platform-drivers: msm: add single-wire serial bus interface (SSBI) driver
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
	<1362616187-21089-2-git-send-email-davidb@codeaurora.org>
	<20130307013008.GA2910@kroah.com>
Date: Mon, 11 Mar 2013 23:51:08 -0700
In-Reply-To: <20130307013008.GA2910@kroah.com> (Greg Kroah-Hartman's message
	of "Thu, 7 Mar 2013 09:30:08 +0800")
Message-ID: <8yamwu9nmar.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

>> +static int ssbi_wait_mask(struct msm_ssbi *ssbi, u32 set_mask, u32 clr_mask)
>> +{
>> +	u32 timeout = SSBI_TIMEOUT_US;
>> +	u32 val;
>> +
>> +	while (timeout--) {
>> +		val = ssbi_readl(ssbi, SSBI2_STATUS);
>> +		if (((val & set_mask) == set_mask) && ((val & clr_mask) == 0))
>> +			return 0;
>> +		udelay(1);
>
> Busy loop?  Really?

Finally was able to dig up some of the reason for this.  The
transactions typically take about 5us.  In the case of contention with
another CPU, it could take as much as 20us.

Would it be sufficient to just explain this in a comment?

David
