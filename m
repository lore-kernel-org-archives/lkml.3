Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3LKV0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:26:24 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:63242 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3LKV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:26:20 -0500
Message-ID: <1386797175.1516.272.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting
 permanent mac address
From: Ben Hutchings <bhutchings@solarflare.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@adurom.com>,
        "Luciano Coelho" <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <freemangordon@abv.bg>,
        <aaro.koskinen@iki.fi>, <pavel@ucw.cz>, <sre@ring0.de>,
        <joni.lapilainen@gmail.com>, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
Date: Wed, 11 Dec 2013 21:26:15 +0000
In-Reply-To: <201312102031.23797@pali>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <201312101852.17030@pali> <1386703339.30202.19.camel@dcbw.foobar.com>
	 <201312102031.23797@pali>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20352.005
X-TM-AS-Result: No--18.341700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 20:31 +0100, Pali Rohár wrote:
[...]
> So, if you like this idea, can you help me how to write udev rule 
> which will run my own program (it print mac address) and send mac 
> address when driver ask for mac address in request_firmware? 
> Problem is that default udev rule for firmware trying to load data 
> from /lib/firmware/... but in this case mac address first must be 
> read from special location and converted to correct format.

Unfortunately, udev no longer supports firmware loading during module
loading (unless that was fixed - I don't think it has been).  Loading
firmware *files* still works because the kernel can read those directly
rather than requesting them from udev.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

