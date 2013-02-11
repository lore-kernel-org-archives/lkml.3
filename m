Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab3BKX2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:28:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:54785 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128Ab3BKX2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:28:36 -0500
X-Greylist: delayed 1821 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2013 18:28:36 EST
Message-ID: <5119777E.6030005@iogearbox.net>
Date: Mon, 11 Feb 2013 23:58:06 +0100
From: Daniel Borkmann <borkmann@iogearbox.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Florian Weimer <fw@deneb.enyo.de>
CC: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
References: <cover.1360528614.git.dborkman@redhat.com> <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com> <87zjzallp5.fsf@mid.deneb.enyo.de>
In-Reply-To: <87zjzallp5.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: borkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 08:00 PM, Florian Weimer wrote:
 > * Daniel Borkmann:

Thanks for your feedback, Florian!

 >> + * memcmp_nta - memcmp that is secure against timing attacks
 >
 > It's not providing an ordering, so it should not have "cmp" in the
 > name.

I agree. What would you suggest? Probably, it would make sense to
integrate this into the Linux crypto API and name it sth like ...

   crypto_mem_verify(const void *,const void *,__kernel_size_t)

... which returns:

   == 0 - mem regions equal each other
   != 0 - mem regions do not equal each other

 >> +	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
 >> +		res |= (*su1 ^ *su2);
 >
 > The compiler could still short-circuit this loop.  Unlikely at
 > present, but this looks like a maintenance hazard.

So then better we leave out '|' as a possible candidate and rewrite it as:

+	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
+		res += (*su1 ^ *su2);
