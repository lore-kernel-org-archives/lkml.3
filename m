Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaCKNXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:23:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58575 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaCKNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:23:10 -0400
Date: Tue, 11 Mar 2014 08:20:13 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Trilok Soni <tsoni@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Anirudh Ghayal <aghayal@codeaurora.org>, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Qualcomm PMIC8xxx keypad never worked?
Message-ID: <20140311132013.GO18529@joshc.qualcomm.com>
References: <5887114.1jrNo21sGX@wuerfel>
 <20140311120056.GH21216@lee--X1>
 <8206209.oc1V5pPVYT@wuerfel>
 <20140311130609.GL21216@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311130609.GL21216@lee--X1>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 01:06:09PM +0000, Lee Jones wrote:
> > > > Something in the MFD_PM8XXX driver must have changed recently that now allows
> > > > the KEYBOARD_PMIC8XXX driver to be enabled. Unfortunately, it does not build
> > > > because of a dependency on the <linux/mfd/pm8xxx/gpio.h> header file that
> > > > does not exist.
> 
> I think it's this commit that's causing your error:
> 
>   https://lkml.org/lkml/2013/12/10/903
> 
> ... but the MFD isn't broken, so I guess your solution is the most
> elegant. If it's not fixed soon, I guess we should think about ripping
> it out. It's obvoious that no-one cares, as it's been broken for
> nearly 3 years.

Stephen has a pending patchset to cleanup and actually make the pm8xxx
input drivers work, but they have not been picked up yet:

http://lkml.kernel.org/r/1393958088-1456-1-git-send-email-sboyd@codeaurora.org

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
