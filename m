Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaA3Obq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:31:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56672 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaA3Obo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:31:44 -0500
Message-ID: <52EA6228.8030008@ti.com>
Date: Thu, 30 Jan 2014 09:31:04 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: keystone: dts: disable "msmcsram" clock
References: <1391082343-13371-1-git-send-email-ivan.khoronzhuk@ti.com> <448912EABC71F84BBCADFD3C67C4BE52A0B4B6@DBDE04.ent.ti.com> <52EA5A8F.7070107@ti.com>
In-Reply-To: <52EA5A8F.7070107@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 January 2014 08:58 AM, Ivan Khoronzhuk wrote:
> Ok. I will delete node for this clock from DT and send v1
> 
Sorry for the html reply first of all. That node should never have
been actually added since the clock is not suppose to be touched even
in low power states. Change log should say something like this ...

"MSMC is the coherency interconnect and all the coherent masters are
connected to it including devices which are not under Linux OS control.
MSMC clock should not be toched even in low power states."

So drop the clock node o.w without 'clk_ignore_unused' will disable
the clock leading to system stall.

I wil try get these in rc's since its a bug fix

Regards,
Santosh



