Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab3CSQWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:22:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33783 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751682Ab3CSQWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:22:41 -0400
Message-ID: <1363710160.1932.49.camel@joe-AO722>
Subject: Re: [PATCH 1/3] kernel/srcu: merge common code into a macro
From: Joe Perches <joe@perches.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Date: Tue, 19 Mar 2013 09:22:40 -0700
In-Reply-To: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de>
References: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 15:16 +0100, Sebastian Andrzej Siewior wrote:
> DEFINE_SRCU() and DEFINE_STATIC_SRCU() does the same thing except for
> the "static" attribute. This patch moves the common pieces into
> _DEFINE_SRCU() which is used by the the former macros either adding the
> static attribute or not.
[]
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
[]
> +#define DEFINE_SRCU(name)		_DEFINE_SRCU(name, )
> +#define DEFINE_STATIC_SRCU(name)	_DEFINE_SRCU(name, static)

I think the use of an empty argument, even in
a macro, unsightly.


