Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaDVDjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:39:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61355 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaDVDjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140419213254.0b4c4b6a@xenia.leun.net>
References: <20140419031554.253c98c3@xenia.leun.net> <20140419213254.0b4c4b6a@xenia.leun.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 21 Apr 2014 20:38:45 -0700
X-Google-Sender-Auth: 2RebOz9vgG3JzoUfFoTlPLdR4Ek
Message-ID: <CAB=NE6Vgvyf-WYwE-9+RjY3RA7kYuX6P=onrgJE6rLwt4c7Y5Q@mail.gmail.com>
Subject: Re: 3.14 Regression, kernel panic when suspend, looks ath9k /
 wireless related
To: Michael Leun <lkml20140418@newton.leun.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k mailing list <ath9k-devel@venema.h4ckr.net>,
        Mihir Shete <smihir@qti.qualcomm.com>,
        Henri Bahini <hbahini@qca.qualcomm.com>,
        Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 12:32 PM, Michael Leun
<lkml20140418@newton.leun.net> wrote:
> 2a901468c221e778af52603e006a53

Odd -- its unclear how you ended up with this bisect given that
REGULATORY_COUNTRY_IE_IGNORE is not set for any driver currently. To
see this you can try:

mcgrof@ergon ~/linux-stable (git::linux-3.14.y)$ git grep
REGULATORY_COUNTRY_IE_IGNORE drivers/net/wireless/

That said, I'm happy to revert this as no driver is using it anyway.
Folks who care for it can help fix this when they get the Fisher Price
(TM) driver upstream. I however don't think however this is the issue
though, this may be a timing issue and by reverting this commit you
just so happen to not get it triggered. I'll Cc you on some series of
fixes and if you can test one of those patches on top of v3.14.1
that'd be appreciated as an alternative. I'm also very curious to hear
no one else would have run into the same regression as you have.

  Luis
