Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaHKSSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:18:36 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33922 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbaHKSSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:18:35 -0400
Message-Id: <1407781112.3399765.151527845.7EC32D9C@webmail.messagingengine.com>
X-Sasl-Enc: 53JfYkI73HLkDWipYhy04HdR1o9edeLXm5GLc8WBzqII 1407781112
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-e309cf77
In-Reply-To: <53E8D876.1060004@zytor.com>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <53E8D876.1060004@zytor.com>
Subject: Re: BUG: early intel microcode update violating alignment rules
Date: Mon, 11 Aug 2014 15:18:32 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014, at 11:51, H. Peter Anvin wrote:
> We could put a buffer in the initdata region (we really could use an
> initbss region!) or in the brk.

That sounds much better than the hideous crap I came up with.  The
buffer would need to be at least 64KiB in size to be on the safe side. 
The largest public microcode update ATM is 23KiB.

I am not sure if we might need more than 64KiB: the Intel SDM mentions
that in real mode the update data must not cross a segment boundary, and
also must not exceed a segment limit.  I am a bit rusty on real mode,
but doesn't that mean, in practice, that microcode update data size is
limited in size to 64KiB?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
