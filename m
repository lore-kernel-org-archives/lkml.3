Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaCXGCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:02:07 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:11376 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaCXGCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:02:05 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat9htPsz+CM
X-RZG-CLASS-ID: mo00
Subject: Re: w1: 3.14-rc7 - possible recursive locking detected
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20140323215041.GB5096@spacedout.fries.net>
Date: Mon, 24 Mar 2014 06:55:51 +0100
Cc: Belisko Marek <marek.belisko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, zbr@ioremap.net
Content-Transfer-Encoding: 7bit
Message-Id: <8EA32A31-37F8-4858-A3A8-CC585065331D@goldelico.com>
References: <CAAfyv37OPxJkcyYi0ZZe9MSQZ3TMeCuxa8rmWh8ahNF6Bs01Mg@mail.gmail.com> <20140323215041.GB5096@spacedout.fries.net>
To: David Fries <David@Fries.net>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 23.03.2014 um 22:50 schrieb David Fries:

> On Mon, Mar 17, 2014 at 10:38:13PM +0100, Belisko Marek wrote:
>> Hi,
>> 
>> booting latest 3.14-rc7 on gta04 board gives following warning:
>> 
>> [    3.101409] Driver for 1-wire Dallas network protocol.
>> [    3.109649] omap_hdq omap_hdq: OMAP HDQ Hardware Rev 0.5. Driver in
>> [    3.400146]        CPU0
>> [    3.402709]        ----
>> [    3.405273]   lock(&(&priv->bus_notifier)->rwsem);
>> [    3.410308]   lock(&(&priv->bus_notifier)->rwsem);
>> [    3.415374]
>> [    3.415374]  *** DEADLOCK ***
>> 
>> AFAIK we didn't see that on (at least 3/14-rc2).
> 
> The last drivers/w1 change went in before v3.14-rc1, so if it is
> something in the w1 code, it has either been there or something else
> in the rest of the kernel changed to expose it.  I'm using the ds2490
> USB w1 dongle, I didn't see that problem when enabling lock debugging
> on 3.14.0-rc5+ which includes some changes I'm working on.
> 
> https://github.com/dfries/linux.git w1_rework

Further analysis shows that It only occurs when using the device tree.

So it may have to do something with nested driver probing/locking running
differently between DT and board file.

BR,
Nikolaus

