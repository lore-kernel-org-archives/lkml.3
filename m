Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaCHWCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 17:02:43 -0500
Received: from r00tworld.com ([212.85.137.150]:54479 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaCHWCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 17:02:42 -0500
From: "PaX Team" <pageexec@freemail.hu>
To: behanw@converseincode.com, Sergei Antonov <saproj@gmail.com>
Date: Sat, 08 Mar 2014 23:01:48 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
Reply-to: pageexec@freemail.hu
CC: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org,
        "=?UTF-8?Q?Jan-Simon_M=C3=B6ller?=" <dl9pf@gmx.de>,
        "=?UTF-8?Q?Vin=C3=ADcius_Tinti?=" <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Message-ID: <531B934C.31666.37555A14@pageexec.freemail.hu>
In-reply-to: <CABikg9y_j-SDOsMj1C5uogP0HNj6bsB_ySVFtAh_oNgZ0swd=g@mail.gmail.com>
References: <1394177091.4653.1.camel@jlt4.sipsolutions.net>, <1394241960-1764-1-git-send-email-behanw@converseincode.com>, <CABikg9y_j-SDOsMj1C5uogP0HNj6bsB_ySVFtAh_oNgZ0swd=g@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Sat, 08 Mar 2014 23:01:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Mar 2014 at 21:29, Sergei Antonov wrote:

> > -       memset(&aead_req, 0, sizeof(aead_req));
> > +       char aead_req_data[sizeof(struct aead_request) +
> > +                               crypto_aead_reqsize(tfm) +
> > +                               CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
                                                     ^^^^^^^^^^^^^^^^^^^^
wouldn't the underlined attribute ensure the required alignment?

> Bad trick with regards to alignment.
> The alignment requirement for struct aead_request is stronger than
> what an array of chars may have.



