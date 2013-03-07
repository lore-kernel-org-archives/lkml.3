Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3CGKYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:24:52 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:58470 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3CGKYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:24:51 -0500
Message-ID: <51386AEF.5090703@free-electrons.com>
Date: Thu, 07 Mar 2013 11:24:47 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Chen <peter.chen@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: v3.9-rc1: swapper/0  [ INFO: possible circular locking dependency
 detected ]
References: <51371B5E.1000508@free-electrons.com> <20130307080843.GG20470@nchen-desktop>
In-Reply-To: <20130307080843.GG20470@nchen-desktop>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Le 07/03/2013 09:08, Peter Chen a écrit :
> On Wed, Mar 06, 2013 at 11:33:02AM +0100, Maxime Ripard wrote:
>> [    2.149645] other info that might help us debug this:
>> [    2.149645] 
>> [    2.157667]  Possible unsafe locking scenario:
>> [    2.157667] 
>> [    2.163598]        CPU0                    CPU1
>> [    2.168134]        ----                    ----
>> [    2.172667]   lock(&(&cdev->lock)->rlock);
>> [    2.176790]                                lock(&(&ci->lock)->rlock);
>> [    2.183255]                                lock(&(&cdev->lock)->rlock);
>> [    2.189893]   lock(&(&ci->lock)->rlock);
> 
> The precondition of above is the chipidea interrupt can be re-entered.
> But as far as I know, the same interrupt can't be re-entered at current
> system.

Yes, it seems to work quite fine anyway, but I'm not sure simply
ignoring this would be the right answer.

Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
