Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3BROek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:34:40 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42907 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3BROej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:34:39 -0500
X-AuditID: 85900ec0-d60ccb900000151e-c0-51223bfcc44a
Message-ID: <51223BFC.3000408@hitachi.com>
Date: Mon, 18 Feb 2013 23:34:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Re: [BUG arm-soc] mvneta: tx queue done sometimes causes kernel
 panic
References: <511DE679.5080801@hitachi.com> <1360947132.19353.15.camel@edumazet-glaptop> <20130216022043.65d5c940@skate>
In-Reply-To: <20130216022043.65d5c940@skate>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/02/16 10:20), Thomas Petazzoni wrote:
> Hello,
> 
> On Fri, 15 Feb 2013 08:52:12 -0800, Eric Dumazet wrote:
> 
>> Driver is buggy, as TX completion can happen both from ndo_start_xmit()
>> and a timer, and there is no spinlock or appropriate synchro.
> 
> Yes, it is a known issue. I did post a patch fixing the problem on
> netdev@ a while ago [1], but while it was fixing the problem, it wasn't
> considered the right approach. Being busy with other Marvell Armada
> 370/XP developments, I haven't yet had the time to investigate the
> issue again.
> 
> [1] https://patchwork.kernel.org/patch/1941601/

Thank you for pointing that.

I've tried the above patch and found at least this panic
disappeared (even if it was not the right approach).

Thanks again!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


