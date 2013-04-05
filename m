Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162339Ab3DESIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:08:23 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50901 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162274Ab3DESIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:08:21 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: Re: Version number policy!
Date: Fri, 5 Apr 2013 20:08:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc5-wl+; KDE/4.8.4; x86_64; ; )
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "linux-bluetooth" <linux-bluetooth@vger.kernel.org>,
        Adrian Chadd <adrian@freebsd.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "ath9k_htc_fw" <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com> <201304051903.11215.chunkeey@googlemail.com> <CAFSJ42bqquh+xekt8+V3wbG3MOUVFELTxR3mNPfS0Jn9J7OURQ@mail.gmail.com>
In-Reply-To: <CAFSJ42bqquh+xekt8+V3wbG3MOUVFELTxR3mNPfS0Jn9J7OURQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304052008.15412.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013 19:23:54 Eugene Krasnikov wrote:
> When it comes to feature bitmap do you have an example of such a
> bitmap from carl9170? 
That's a weird way of asking. No, I don't have an example?!
But carl9170fw_feature_list is used in "production".

Anyway, there is one defined in:
<https://github.com/chunkeey/carl9170fw/blob/master/include/shared/fwdesc.h#L26>

It's packed into the OTUS firmware descriptor:
<https://github.com/chunkeey/carl9170fw/blob/master/include/shared/fwdesc.h#L118>

And the descriptor is filled in:
<https://github.com/chunkeey/carl9170fw/blob/master/carlfw/src/fw.c>

[Basically, a bit for every feature in kconfig.]

Of course, the nice thing is, if you have something like
kconfig (carl9170fw.git uses a pretty much the vanilla kernel
kconfig. Everything apart from the cmake scripts for gperf
(which is in extra/) is packed into the conf/ directory.

And it has the necessary cmake files. So it should integrate 
well into the "new" ath9k_htc cmake build system Felix made.

> Why not to rely always on major version?
Ok, let's do the same with major version...

if  ((fw_major == 1 && fw_minor > 30) ||
     (fw_major == 2 && fw_minor > 7) ||
     (fw_major == 3 && fw_minor > 3) ||
     (fw_major > 4))
      feature_supported = true;

Nope, I think it looks just as bad.
[Please, explain what you meant to say...
Because the new versioning draft stats that very
major release is incompatible with the old one and
clearly, having to support a ton of different firmware
trees is no joy.... and not necessary]

BTW: Instead of a GET_BUILD command, why not make a add a
firmware header or pack the information into the tail... 

This way, it can be read and parsed by tools, without having
to upload it to the device first.

carl9170fw already such a tool, it's called: fwinfo and it is located in: 
<https://github.com/chunkeey/carl9170fw/blob/master/tools/src/fwinfo.c>

Regards,
	Christian
