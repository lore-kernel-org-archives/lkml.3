Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaBDSIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:08:52 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:63039 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaBDSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:08:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVCeFek2LX0_AnA8zg_yYhXvzw19rH8OsqbWWb-rb9w-A@mail.gmail.com>
References: <CAMuHMdVCeFek2LX0_AnA8zg_yYhXvzw19rH8OsqbWWb-rb9w-A@mail.gmail.com>
Date: Tue, 4 Feb 2014 10:08:48 -0800
Message-ID: <CAHA+R7Omv++NCg=nocVsW+tM=Zv_qCNhX1JjtFTuCzfz9B3Cig@mail.gmail.com>
Subject: Re: [bisected] Re: WARNING: at net/ipv4/devinet.c:1599
From: Cong Wang <cwang@twopensource.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 6:19 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Anyone with a clue?
>

Looks like we need:

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index ac2dff3..bdbf68b 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1443,7 +1443,8 @@ static size_t inet_nlmsg_size(void)
               + nla_total_size(4) /* IFA_LOCAL */
               + nla_total_size(4) /* IFA_BROADCAST */
               + nla_total_size(IFNAMSIZ) /* IFA_LABEL */
-              + nla_total_size(4);  /* IFA_FLAGS */
+              + nla_total_size(4)  /* IFA_FLAGS */
+              + nla_total_size(sizeof(struct ifa_cacheinfo)); /*
IFA_CACHEINFO */
 }

 static inline u32 cstamp_delta(unsigned long cstamp)
