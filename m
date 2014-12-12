Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030957AbaLLRLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:11:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030303AbaLLRLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:11:45 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Krzysztof Konopko <kris@konagma.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
	<548A2E7A.4010303@lwfinger.net> <548AD2F1.3080200@konagma.com>
Date: Fri, 12 Dec 2014 12:10:36 -0500
In-Reply-To: <548AD2F1.3080200@konagma.com> (Krzysztof Konopko's message of
	"Fri, 12 Dec 2014 12:35:13 +0100")
Message-ID: <wrfjbnn8yesz.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Konopko <kris@konagma.com> writes:
> On 12/12/14 00:53, Larry Finger wrote:
>> In RTL8188EU, both BA_starting_seqctrl and TXOP_limit are unsigned short.
>> 
>
> That's not quite the case.  `TXOP_limit` is __le16 in RTL8188EU [1].
> It's __le16 even in your GitHub repo [2].  And that made me thinking
> that there's probably some inconsistency in the header.
>
> I'm _far_ from being a wireless expert but doesn't data coming out of
> the wire/air have the endianess defined explicitly?  And both `AC_param`
> and `ADDBA_request` come out of air?
>
> I was hunting particularly for inconsistencies with `sparse` and came
> across this one.  But I dug a bit further and I wonder why the driver is
> not using standard stuff like the one in `include/linux/ieee80211.h`
> where any data wider than one byte is clearly declared as __le<nn>?

In general all over the wire data is little-endian. The driver has been
slowly moved towards using the standard defines from the Linux headers,
but this is a *lot* of work, and it requires testing. I really don't get
warm fuzzy feelings from patches that blindly make these kinds of
changes without also testing them.

Jes
