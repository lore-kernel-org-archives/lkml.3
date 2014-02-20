Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBTVHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:07:34 -0500
Received: from forward5m.mail.yandex.net ([37.140.138.5]:40427 "EHLO
	forward5m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaBTVHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:07:31 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: David Fries <david@fries.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140219071911.GA26209@spacedout.fries.net>
References: <20140211164513.GF5530@spacedout.fries.net>
 <20140211210755.GA25579@elgon.mountain>
 <85681392392562@web18h.yandex.ru> <20140219071911.GA26209@spacedout.fries.net>
Subject: Re: [PATCH] w1: bundle reply if the request was bundled
MIME-Version: 1.0
Message-Id: <204041392930448@web28m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 21 Feb 2014 01:07:28 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

19.02.2014, 11:19, "David Fries" <david@fries.net>:
> A program can bundle multiple messages and commands together when
> making one wire requests, which is going to be much more efficient
> than sending lots of little packets one write at a time. šWith this
> change the kernel will then bundle responses to requests that were
> bundled, where it's probably even more important because programs will
> typically execute select or a poll operation between reading packets,
> which takes additional context switches.


Your approach and patch seem correct, but I worry about how old commands are processed.
Do I get it right, that replies to old non-bundle commands are queued back instead of sending immediately,
but since it is not bundle but single command, queued reply is being sent 'almost' immediately?
Basically, nothing changed to old clients, but there is new way to send batch requests now?

And please make indent less paranoid about line length, it is really hard to read some lines,
which were broken into pieces just because of that.
