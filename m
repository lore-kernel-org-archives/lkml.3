Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaBGWbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 17:31:35 -0500
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:55184 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaBGWbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 17:31:34 -0500
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Feb 2014 17:31:33 EST
Message-ID: <1391811934.18534.54.camel@porter.coelho.fi>
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
From: Luca Coelho <luca@coelho.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@adurom.com>, Johannes Berg <johannes@sipsolutions.net>,
        Calvin Owens <jcalvinowens@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 08 Feb 2014 00:25:34 +0200
In-Reply-To: <52F4FFD5.5070808@lwfinger.net>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
		<1391675824.12789.3.camel@jlt4.sipsolutions.net>
	 <87r47fkrsj.fsf@purkki.adurom.net> <52F4FFD5.5070808@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 09:46 -0600, Larry Finger wrote:
> On 02/07/2014 06:53 AM, Kalle Valo wrote:
> > Johannes Berg <johannes@sipsolutions.net> writes:
> >
> >> On Wed, 2014-02-05 at 19:44 -0600, Calvin Owens wrote:
> >>> Create a function to return a descriptive string for each reason code,
> >>> and print that instead of the numeric value in the kernel log. These
> >>> codes are easily found on popular search engines, but one is generally
> >>> not able to access the internet when dealing with wireless connectivity
> >>> issues.
> >>
> >> I believe both iw and wpa_supplicant already have the reason code
> >> printout, and if you're diagnosing connectivity issues then you're
> >> probably using those anyway (e.g. iw event -t), so I don't really see
> >> much point in adding this to the kernel?
> >
> > FWIW I find this useful. When I have connection problems I rarely look
> > at wpasupplicant, mostly I'm so lazy that I just check from the kernel
> > log what's happening. Just my 0.02 EUR.
> 
> I would also find it useful. I assist with wireless problems on the openSUSE 
> Forum, and there we are lucky if we get dmesg output. When we do and it contains 
> a deauthentication reason, I always need to bring up a web page to interpret the 
> output. With this change, one step could be skipped.

But is it worth putting this parsing in the *kernel*? I mean, if anyone
is interested enough in the problem, a simple google query is not that
hard, right?

If this happens to you "on-the-fly" and all you want is your connection
to work, you won't start debugging right away.  You'll (maybe) save the
kernel logs, try to reconnect and debug later, at home.

If you think you *can* fix the problem on-the-fly, but you can't google
because the connection doesn't work, you certainly have either the IEEE
802.11 specs or the kernel sources somewhere in your device. :)

--
Luca.

