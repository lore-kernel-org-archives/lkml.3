Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbaBDX7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:59:01 -0500
Received: from forward16.mail.yandex.net ([95.108.253.141]:45526 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbaBDX7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:59:00 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Feb 2014 18:58:59 EST
From: zbr@ioremap.net
Envelope-From: drustafa@yandex.ru
To: David Fries <david@fries.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140204055131.GI5342@spacedout.fries.net>
References: <1391390104-31154-1-git-send-email-David@Fries.net>
 <9071391471978@web15j.yandex.ru> <20140204055131.GI5342@spacedout.fries.net>
Subject: Re: [PATCH 0/4] w1: refcnt fix, skip non-error send, docs
MIME-Version: 1.0
Message-Id: <253061391557725@web20g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 05 Feb 2014 03:48:45 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

04.02.2014, 09:51, "David Fries" <david@fries.net>:
> Help me understand what the protocol is supposed to be. šAssuming
> there aren't any errors, is there supposed to be a
> w1_netlink_send_error generated reply per netlink packet (cn_msg), per
> w1_netlink_msg, or per w1_netlink_cmd?

reply should be sent per cmd to specify each command status
If there is no cmd in request or we didn't get to it (like failed to reset device), we should send error.

Depending on how w1-msg + (optional) w1-cmd are packed, client can detect what exact error happend

> What about the cn_msg seq and ack values? šI assume the kernel
> response should carry the same seq number as the request, but what
> should the ack be set to?

reply ack is seq + 1
seq is the same to highlight request it belongs to
