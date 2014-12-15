Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaLOPhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:37:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaLOPhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:37:06 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Krzysztof Konopko <kris@konagma.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
	<548A2E7A.4010303@lwfinger.net> <548AD2F1.3080200@konagma.com>
	<548B2752.7030607@lwfinger.net> <wrfjwq5wwvik.fsf@redhat.com>
	<548B7249.1060602@konagma.com>
Date: Mon, 15 Dec 2014 10:36:52 -0500
In-Reply-To: <548B7249.1060602@konagma.com> (Krzysztof Konopko's message of
	"Fri, 12 Dec 2014 23:55:05 +0100")
Message-ID: <wrfjoar4vsa3.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Konopko <kris@konagma.com> writes:
> On 12/12/14 19:52, Jes Sorensen wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>> On 12/12/2014 05:35 AM, Krzysztof Konopko wrote:
>>>> I was hunting particularly for inconsistencies with `sparse` and came
>>>> across this one.  But I dug a bit further and I wonder why the driver is
>>>> not using standard stuff like the one in `include/linux/ieee80211.h`
>>>> where any data wider than one byte is clearly declared as __le<nn>?
>>>
>>> That is a good question. One possibility is that those definitions do
>>> not exist on some of the older kernels that Realtek supports. They
>>> generally work with 2.6.18 and newer.
>> 
>> The reason the 8723au driver doesn't use the defines from there is that
>> in ieee80211.h they are part of struct ieee80211_mgmt, while the 8723au
>> driver access the addba etc. elements without the full struct in place.
>> 
>
> And why is that the case?
> (I'm trying to understand, not debunk)
>
> Looks to me that this driver has been kept out of the tree for quite a
> while (by Realtek) and now suffers from locally invented stuff.  I
> understand this is a lot of work to unify the codebase with ieee80211.h,
> but are there any technical hurdles?  I'm just curious.

The main issue is that the RTL driver maintains a partial copy of the
management frame, ie. without the front block containing the MAC
addresses. Switching this over to carry a full copy of the frame is
extremely intrusive as it's mixed in pretty much everywhere in the
driver.

The driver is derived from Realtek's multi-OS vendor driver, which
included code for pretty much every OS on the planet. If you want to see
how it looked initially, check out Larry's github tree and go back to
the initial checkins .... Realtek seem to copy it into a new tree and
devel from there whenever they do a new chip, so the legacy in this
codebase is huge.

Cheers,
Jes
