Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaCLDX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:23:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33170 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaCLDX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:23:27 -0400
Date: Tue, 11 Mar 2014 23:23:25 -0400 (EDT)
Message-Id: <20140311.232325.2172162494177450404.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, fwestpha@redhat.com
Subject: Re: [PATCHv2 1/2] bridge: multicast: add sanity check for general
 query destination
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394486725-4992-1-git-send-email-linus.luessing@web.de>
References: <1394486725-4992-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Mar 2014 20:23:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Mon, 10 Mar 2014 22:25:24 +0100

> General IGMP and MLD queries are supposed to have the multicast
> link-local all-nodes address as their destination according to RFC2236
> section 9, RFC3376 section 4.1.12/9.1, RFC2710 section 8 and RFC3810
> section 5.1.15.
> 
> Without this check, such malformed IGMP/MLD queries can result in a
> denial of service: The queries are ignored by most IGMP/MLD listeners
> therefore they will not respond with an IGMP/MLD report. However,
> without this patch these malformed MLD queries would enable the
> snooping part in the bridge code, potentially shutting down the
> according ports towards these hosts for multicast traffic as the
> bridge did not learn about these listeners.
> 
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

Applied.
