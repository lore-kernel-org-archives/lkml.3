Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaKQF4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 00:56:30 -0500
Received: from mailsec118.isp.belgacom.be ([195.238.20.114]:48313 "EHLO
	mailsec118.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbaKQF43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 00:56:29 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=IWjTSwFp5QM033bvc92RfzEeQuXC3aWfw/K7N4S/aa4= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=P3ZWvcO_lz5jeCzNWj0A:9 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8KAMyMaVTD7hTU/2dsb2JhbABbgw6BLoMGtUEGmwoCgRcWAQEBAQF9hAIBAQEDASNWBQsFBhgCAhgOAgIhNgYTEYgbAwkNuwGHAodtDYZaAQEBBwIBH4EthRGIJoI+B4J3gVQFnDmSGIZ1g308MIJLAQEB
Date: Mon, 17 Nov 2014 06:56:27 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        b43-dev <b43-dev@lists.infradead.org>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        "John W. Linville" <linville@tuxdriver.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Message-ID: <828430032.148603.1416203787175.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <CAGRGNgWqjsDu_mQK=_agBWjOequb4b7ffgCuxRH=9d72grDYtQ@mail.gmail.com>
References: <1415998553-12636-1-git-send-email-fabf@skynet.be> <CAGRGNgWqjsDu_mQK=_agBWjOequb4b7ffgCuxRH=9d72grDYtQ@mail.gmail.com>
Subject: Re: [PATCH 1/1 net-next] wireless: remove unnecessary sizeof(u8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 16 November 2014 at 23:33 Julian Calaby <julian.calaby@gmail.com> wrote:
>
>
> Hi Fabian,
>
> On Sat, Nov 15, 2014 at 7:55 AM, Fabian Frederick <fabf@skynet.be> wrote:
> > sizeof(u8) is always 1.
>
> I thought that sizeof(*variable) was preferred over sizeof(type), so
> shouldn't these be switched to that format instead?
>
> (I know that this is all no-op, but it should reduce the potential for
> highly unlikely bugs in the future. Also, the extra processing is
> compile-time not run-time.)
>
> Thanks,

Hi Julian,

Of course but char/u8/s8... allocations never use it and result would be the
same:
factor 1 multiplication.

Those rare occurrences (+- 30 in the whole kernel) where we have
sizeof(u8/s8) is ambiguous.

Having a patch removing it gives a pointer...
If the developer meant something else, he will be able to fix it.

Regards,
Fabian
