Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaBJLJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:09:17 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:45422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaBJLJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:09:16 -0500
Message-ID: <1392030546.4128.11.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Calvin Owens <jcalvinowens@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 12:09:06 +0100
In-Reply-To: <1391661863.30094.56.camel@joe-AO722>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	 <1391661863.30094.56.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-05 at 20:44 -0800, Joe Perches wrote:

> Perhaps use a more common kernel style
> 
> struct ieee80211_reason_descriptions {
> 	u16		code;
> 	const char *	desc;
> }
> 
> and enumerate the reason codes with #defines and use a
> macro to populate the descriptions
> 
> #define IEEE80211_REASON_RESERVED		0
> #define IEEE80211_REASON_UNSPECIFIED		1
> 
> etc.
> 
> #define POPULATE_IEEE_REASON(code)			\
> 	{.code = IEEE80211_REASON_##code, .desc = #code}
> 
> static const struct ieee80211_reason_descriptions reasons[] = {
> 	POPULATE_IEEE_REASON(RESERVED),
> 	POPULATE_IEEE_REASON(UNSPECIFIED),
> 	[etc...]
> };
> 
> So this function becomes something like:
> 
> const char *ieee80211_get_reason_code_string(u16 reason_code)
> {
> 	int i;
> 
> 	for (i = 0; i < ARRAY_SIZE(reasons); i++) {
> 		if (reasons[i].code == reason_code)
> 			return reasons[i].desc;
> 	}

Isn't it more efficient to just let the compiler generate it with a big
switch() statement? AFAICT gcc will typically generate code like
Calvin's original hand-rolled code and/or big lookup tables anyway, if
faced with something like

switch (reason) {
case 17: return "asdf";
... // all the others
default: return "<unknown>";
};

In any case, I agree with you and Jouni about leaving the number -
that's certainly needed - but I'm willing to merge a clean patch like
this too.

johannes

