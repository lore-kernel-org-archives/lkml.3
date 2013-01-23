Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3AWROE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:14:04 -0500
Received: from minus.inr.ac.ru ([194.67.69.97]:54365 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752976Ab3AWROB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:14:01 -0500
X-Greylist: delayed 3181 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2013 12:14:00 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=d5BbddnyMqYhlmMAldnFeSD/Vz9r/Kw+JPcPm4R08ArV1qtbbooFVcrDOHnK7BYQceXcq8mOJS6AJyWb7O+nIIRiwVjJb+dZ4c6rtdXErdvfeJiGtOPfsdGTEeEyzATxbgZ96GouBDtobK8gq4DHAdXbatYAQGNeJRUoZKZZDVA=;
Date: Wed, 23 Jan 2013 20:20:25 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Andrey Vagin <avagin@openvz.org>
Cc: netdev@vger.kernel.org, criu@openvz.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] [RFC] tcp: add ability to set a timestamp offset (v2)
Message-ID: <20130123162025.GA2147@ms2.inr.ac.ru>
References: <1358953314-12979-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358953314-12979-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Wed, Jan 23, 2013 at 07:01:52PM +0400, Andrey Vagin wrote:
> -#define tcp_time_stamp         ((__u32)(jiffies))
> +#define tcp_time_stamp(tp)     ((__u32)(jiffies) + tp->tsoffset)

This implies that you always have some tp in hands. AFAIK this is not true,
so that I am puzzled how you were able to make something compilable with this definition.

At least in tcp_v4_send_ack() you obviously use some invalid tp, there is
no socket in hands there. The thing which is called "sk" is dummy.

With container migration I used per-container offset. When you have no container,
you have to do something a little bit smarter.

Alexey
