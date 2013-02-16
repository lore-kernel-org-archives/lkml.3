Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab3BPBVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 20:21:02 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:33810 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3BPBVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 20:21:00 -0500
Date: Sat, 16 Feb 2013 02:20:43 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-arm-kernel@lists.infradead.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [BUG arm-soc] mvneta: tx queue done sometimes causes kernel
 panic
Message-ID: <20130216022043.65d5c940@skate>
In-Reply-To: <1360947132.19353.15.camel@edumazet-glaptop>
References: <511DE679.5080801@hitachi.com>
	<1360947132.19353.15.camel@edumazet-glaptop>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 15 Feb 2013 08:52:12 -0800, Eric Dumazet wrote:

> Driver is buggy, as TX completion can happen both from ndo_start_xmit()
> and a timer, and there is no spinlock or appropriate synchro.

Yes, it is a known issue. I did post a patch fixing the problem on
netdev@ a while ago [1], but while it was fixing the problem, it wasn't
considered the right approach. Being busy with other Marvell Armada
370/XP developments, I haven't yet had the time to investigate the
issue again.

[1] https://patchwork.kernel.org/patch/1941601/

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
