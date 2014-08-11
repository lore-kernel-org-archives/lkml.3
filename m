Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaHKSsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:48:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55196 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbaHKSsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:48:54 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1407781112.3399765.151527845.7EC32D9C@webmail.messagingengine.com>
References: <20140809231911.GA4843@khazad-dum.debian.net> <53E8D876.1060004@zytor.com> <1407781112.3399765.151527845.7EC32D9C@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: BUG: early intel microcode update violating alignment rules
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 11 Aug 2014 11:48:25 -0700
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>
CC: linux-kernel@vger.kernel.org
Message-ID: <06991931-9f04-49fc-9ef7-ba23384aeb32@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think so.  I wouldn't count on that in the long run.

I'm having some discussions about this integrally at the moment.

On August 11, 2014 11:18:32 AM PDT, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
>On Mon, Aug 11, 2014, at 11:51, H. Peter Anvin wrote:
>> We could put a buffer in the initdata region (we really could use an
>> initbss region!) or in the brk.
>
>That sounds much better than the hideous crap I came up with.  The
>buffer would need to be at least 64KiB in size to be on the safe side. 
>The largest public microcode update ATM is 23KiB.
>
>I am not sure if we might need more than 64KiB: the Intel SDM mentions
>that in real mode the update data must not cross a segment boundary,
>and
>also must not exceed a segment limit.  I am a bit rusty on real mode,
>but doesn't that mean, in practice, that microcode update data size is
>limited in size to 64KiB?

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
