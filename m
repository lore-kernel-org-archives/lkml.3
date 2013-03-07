Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab3CGSus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:50:48 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9804 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab3CGSuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:50:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,803,1355126400"; 
   d="scan'208";a="27851860"
From: David Brown <davidb@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] platform-drivers: msm: add single-wire serial bus interface (SSBI) driver
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
	<1362616187-21089-2-git-send-email-davidb@codeaurora.org>
	<20130307013008.GA2910@kroah.com> <8yawqtjvl8y.fsf@huya.qualcomm.com>
	<20130307060117.GA31687@kroah.com>
Date: Thu, 07 Mar 2013 10:50:40 -0800
In-Reply-To: <20130307060117.GA31687@kroah.com> (Greg Kroah-Hartman's message
	of "Thu, 7 Mar 2013 14:01:17 +0800")
Message-ID: <8yafw07ujr3.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

>> Without this device, the PMIC drivers won't work, regulators can't be
>> turned on, and most of the other devices won't work.  I can try if it
>> can still be made a module, and it might be good at exercising the
>> deferred probe mechanism.
>
> If the PMIC drivers are dependant on the symbols in this module, there
> should not be any problems, right?

The PMIC drivers directly will be, but the users of gpios/irqs and
regulators coming from the PMIC will only depend on the generic APIs for
this.  In theory, the deferred probe should handle this, and it might
be useful for testing.

I can allow it to be a module, although I don't picture that really
being a useful configuration.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
