Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab3LWWzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:55:23 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:8939 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab3LWWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 17:55:21 -0500
Message-ID: <1387839316.1635.8.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH v4 0/2] sctp: Consolidate and ratelimit deprecation
 warnings
From: Ben Hutchings <bhutchings@solarflare.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: <linux-sctp@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>,
        "David Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 23 Dec 2013 22:55:16 +0000
In-Reply-To: <1387805383-21500-1-git-send-email-nhorman@tuxdriver.com>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
	 <1387805383-21500-1-git-send-email-nhorman@tuxdriver.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20378.006
X-TM-AS-Result: No--17.831100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 08:29 -0500, Neil Horman wrote:
> The SCTP protocol has several deprecation warnings in its setsockopt path that
> can be triggered by unprivlidged users.  Since these are not ratelimited, we can
> spam the logs quite easily here.  Since these are all deprecation warnings, and
> that type of warning isn't uncommon in the rest of the kernel, lets make a
> common pr_warn_deprecated macro to produce somewhat generalized ratelimited
> deprecation warnings easily
[...]

No objection to these changes, but I think deprecation warnings should
log at least the command name and maybe also the pid of the caller.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

