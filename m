Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaE1FAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 01:00:08 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:46019 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaE1FAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 01:00:06 -0400
Message-ID: <53856D51.40304@gmail.com>
Date: Wed, 28 May 2014 07:00:01 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Elie De Brauwer <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <steve@chygwyn.com>,
        =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1v?= =?UTF-8?B?bnQ=?= 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>,
        Chris Friesen <chris.friesen@windriver.com>
Subject: Re: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
References: <536101C9.9090601@gmail.com> <CAKgNAkgA_xTfRZhpyVwuACpCY7xMK89e0bK4PuVMG9reNV6Skw@mail.gmail.com> <20140512143451.GB13801@kernel.org> <20140521210535.GA5414@kernel.org> <537E0961.8040005@gmail.com> <20140526134647.GB8176@kernel.org> <20140526211706.GA25474@kernel.org> <5384BEC5.2080607@gmail.com> <20140527192115.GD25474@kernel.org> <CAKgNAkht1vubHueYPpkRu_W5B8OYW3rPUkHeLEq5WMVbCvO47w@mail.gmail.com> <20140527203010.GA2764@kernel.org>
In-Reply-To: <20140527203010.GA2764@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 10:30 PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, May 27, 2014 at 09:28:37PM +0200, Michael Kerrisk (man-pages) escreveu:
>> On Tue, May 27, 2014 at 9:21 PM, Arnaldo Carvalho de Melo
>> <acme@ghostprotocols.net> wrote:
>>> Em Tue, May 27, 2014 at 06:35:17PM +0200, Michael Kerrisk (man-pages) escreveu:
>>>> On 05/26/2014 11:17 PM, Arnaldo Carvalho de Melo wrote:
>>>>> Can you try the attached patch on top of the first one?
>>>
>>>> Patches on patches is a way to make your testers work unnecessarily
>>>> harder. Also, it means that anyone else who was interested in this
>>>
>>> It was meant to highlight the changes with regard to the previous patch,
>>> i.e. to make things easier for reviewing.
>>
>> (I don't think that works...)
> 
> Lets try both then, attached goes the updated patch, and this is the
> diff to the last combined one:

What tree does this apply to? I tried applying to 3.15-rc7, but a piece 
was rejected, and the fix was not obvious.

Cheers,

Michael


drivers/net/tun.c.rej

--- drivers/net/tun.c
+++ drivers/net/tun.c
@@ -1343,7 +1343,7 @@
 
        /* Read frames from queue */
        skb = __skb_recv_datagram(tfile->socket.sk, noblock ? MSG_DONTWAIT : 0,
-                                 &peeked, &off, &err);
+                                 &peeked, &off, &err, timeop);
        if (skb) {
                ret = tun_put_user(tun, tfile, skb, iv, len);
                kfree_skb(skb);
