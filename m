Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab3CLLhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:37:31 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:57584 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3CLLh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:37:29 -0400
Message-ID: <513F132B.4060606@ahsoftware.de>
Date: Tue, 12 Mar 2013 12:36:11 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: Lubomir Rintel <lkundrak@v3.sk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lubomir Rintel <lubo.rintel@gooddata.com>
Subject: Re: [PATCH] mv643xx_eth: Fix a possible deadlock upon ifdown
References: <1357308422-19639-1-git-send-email-lkundrak@v3.sk> <20130104202509.GX27530@wantstofly.org> <5130E5A5.90303@ahsoftware.de> <20130312024932.GF850@wantstofly.org> <513EEF83.9070806@ahsoftware.de>
In-Reply-To: <513EEF83.9070806@ahsoftware.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.03.2013 10:04, schrieb Alexander Holler:

> I don't think so. Internally the driver calls mv643xx_eth_stop()
> therefore lockdep issues almost the same warning as when the interface
> is shut down (see below). And reading the code, I haven't seen how a

Btw. I consider the shutdown of the interface for just changing the MTU 
more a problem than that lockdep-warning.

E.g. I had serious problems with dhcpcd which sets the MTU to 1500 when 
an interface appears. What then happened was the following:

(1) interface comes up
(2) dhcpcd sets MTU to 1500
(3) a different MTU comes through DHCP
(4) driver shuts down if, sets MTU, turns on IF
back to (1) (endless loop)

I'm not sure if dhcpcd still does that (it's some time since I 
discovered and reported that), but I consider it a crude way to shut 
down the IF to set the MTU.

Regards,

Alexander

