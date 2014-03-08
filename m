Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaCHXmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:42:09 -0500
Received: from mout.gmx.net ([212.227.17.22]:63184 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbaCHXmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:42:07 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CABikg9x+Z95bHcDc6iu5hBvRNO-ibM8-34_qA+OA_FjB52SPMw@mail.gmail.com>
References: <1394177091.4653.1.camel@jlt4.sipsolutions.net> <1394241960-1764-1-git-send-email-behanw@converseincode.com> <CABikg9y_j-SDOsMj1C5uogP0HNj6bsB_ySVFtAh_oNgZ0swd=g@mail.gmail.com> <531B934C.31666.37555A14@pageexec.freemail.hu> <CABikg9x+Z95bHcDc6iu5hBvRNO-ibM8-34_qA+OA_FjB52SPMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v2] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
From: =?ISO-8859-1?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>
Date: Sun, 09 Mar 2014 00:41:41 +0100
To: Sergei Antonov <saproj@gmail.com>, pageexec@freemail.hu
CC: behanw@converseincode.com, John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        =?ISO-8859-1?Q?Vin=EDcius_Tinti?= <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Message-ID: <fcb4c551-996e-42e4-a9ff-ac3c8f3bc5ea@email.android.com>
X-Provags-ID: V03:K0:CXLgCq04deFPX3DxzCewa+shHTPdb7QLJy6HJrk7hbXEaiP3lW5
 8x2d4dD0BfIUyJEMrDhCh6IPwyKGEaf83DvFO/ha1rzN1Fb4TcF7wsAd2lsi4vfFHTfNH+8
 +ZAjuBd5fDBHRQQnXqaXGGINFzT+Ny8GR1YTbZQFEvt5D5n82pRKFj1cwisOgTJGYCGcJDi
 iAYD6HSBkfS9yVZ64iaxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9. März 2014 00:00:19 MEZ, Sergei Antonov <saproj@gmail.com> wrote:
>On 8 March 2014 23:01, PaX Team <pageexec@freemail.hu> wrote:
>> On 8 Mar 2014 at 21:29, Sergei Antonov wrote:
>>
>>> > -       memset(&aead_req, 0, sizeof(aead_req));
>>> > +       char aead_req_data[sizeof(struct aead_request) +
>>> > +                               crypto_aead_reqsize(tfm) +
>>> > +                               CRYPTO_MINALIGN]
>CRYPTO_MINALIGN_ATTR;
>>                                                     
>^^^^^^^^^^^^^^^^^^^^
>> wouldn't the underlined attribute ensure the required alignment?
>Yes. Sorry, I overlooked it.
>
>I would remove unneeded CRYPTO_MINALIGN and get the alignment from the
>target structure:
>        char aead_req_data[sizeof(struct aead_request) +
>                           crypto_aead_reqsize(tfm)]
>        __attribute__((__aligned__(__alignof__(struct aead_request))));



LGTM



-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
