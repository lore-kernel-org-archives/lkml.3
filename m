Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbaHHQeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:34:01 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34214 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbaHHQd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:33:59 -0400
Date: Fri, 8 Aug 2014 09:33:56 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <netdev@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen-netback: Turn off the carrier if the
 guest is not able to receive
Message-ID: <20140808093356.04d7228b@haswell.linuxnetplumber.net>
In-Reply-To: <53DFA30E.2000301@citrix.com>
References: <1406749849-4356-1-git-send-email-zoltan.kiss@citrix.com>
	<1406749849-4356-2-git-send-email-zoltan.kiss@citrix.com>
	<53DF8C24.6030709@citrix.com>
	<53DFA30E.2000301@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This idea of bouncing carrier is wrong. If guest is flow blocked you don't
want to toggle carrier. That will cause problems because applications that are
looking for carrier transistions like routing daemons will be notified.

If running a routing daemon this will also lead to link flapping which
is very bad and cause lots of other work for peer routing daemons.

Carrier is not a suitable flow control mechanism.
