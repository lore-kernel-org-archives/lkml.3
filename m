Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306AbaFUJgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 05:36:44 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:11345 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748AbaFUJgm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 05:36:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYaAJZRpVNXQwKa/2dsb2JhbABYgw2DSKgFAQEBAQEBBQGZJAICAQEBgQgXdYQDAQEEAVYjBQsIAxguOR4GE4g6DAHJMReFYohhMweEQwEDmkMBk1qDRDs
Date: Sat, 21 Jun 2014 11:36:53 +0200
From: Fabian Frederick <fabf@skynet.be>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>, netdev@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/1] net/dsa/dsa.c: remove null test before kfree
Message-Id: <20140621113653.6b2dd148b35a6ecfb7c08cce@skynet.be>
In-Reply-To: <b991e868-c253-4b1a-8c95-56106c36d512@email.android.com>
References: <1403296607-6065-1-git-send-email-fabf@skynet.be>
	<b991e868-c253-4b1a-8c95-56106c36d512@email.android.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2014 10:37:24 +0200
Bjørn Mork <bjorn@mork.no> wrote:

> 
> 
> On 20 June 2014 22:36:47 CEST, Fabian Frederick <fabf@skynet.be> wrote:
> >Fix checkpatch warning:
> >WARNING: kfree(NULL) is safe this check is probably not required
> 
> "probably not" implies that there are cases where the check *is* required.  That means that your commit message should explain why this particular check is redundant.
> 
> I haven't analyzed your changes here, so they could be fine for all I know. My point is that such analysis is your job when submitting cleanups like this one.
> 
> 
> 
AFAIK, any

if(foo)
	kfree(foo)
	
can be updated to kfree(foo) but

if (foo){
	kfree(foo)
	do something else
}

has to be evaluated ; reason for the "probably" in warning message.
If I'm wrong maybe we could be more verbose in checkpatch :)
(I added Joe Perches in Cc list ; maybe he can help here)

Fabian

> Bjørn
