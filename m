Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaAIUmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:42:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33701 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaAIUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:42:35 -0500
Date: Thu, 09 Jan 2014 15:42:32 -0500 (EST)
Message-Id: <20140109.154232.65818281679170677.davem@davemloft.net>
To: dan.j.williams@intel.com
Cc: ncardwell@google.com, dmaengine@vger.kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, jmorris@namei.org, kuznet@ms2.inr.ac.ru,
        kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] net: make tcp_cleanup_rbuf private
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAPcyv4hPnCud=MWpsCMNZmK_BwVV8WZHOs7=GQMhymgkv-gNkw@mail.gmail.com>
References: <20140109201642.28381.82141.stgit@viggo.jf.intel.com>
	<CADVnQy=Tk68y217cbw7O5apCJV+eOmKMqLNbgAZRa_cxUArdKg@mail.gmail.com>
	<CAPcyv4hPnCud=MWpsCMNZmK_BwVV8WZHOs7=GQMhymgkv-gNkw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 09 Jan 2014 12:42:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Jan 2014 12:33:29 -0800

> On Thu, Jan 9, 2014 at 12:26 PM, Neal Cardwell <ncardwell@google.com> wrote:
>> On Thu, Jan 9, 2014 at 3:16 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> net_dma was the only external user so this can become local to tcp.c
>>> again.
>> ...
>>> -void tcp_cleanup_rbuf(struct sock *sk, int copied)
>>> +static void cleanup_rbuf(struct sock *sk, int copied)
>>
>> I would vote to keep the tcp_ prefix. In the TCP code base that is the
>> more common idiom, even for internal/static TCP functions, and
>> personally I find it easier to read and work with in stack traces,
>> etc. My 2 cents.
>>
> 
> Ok.  It was cleanup_rbuf() in a former life, but one vote for leaving
> the name as is is enough for me.

You can make that two votes :)
