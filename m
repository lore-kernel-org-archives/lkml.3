Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaAaAyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:54:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40616 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaAaAyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:54:25 -0500
MIME-Version: 1.0
X-Originating-IP: [109.128.142.46]
In-Reply-To: <20140130150503.GA29607@redhat.com>
References: <1391088002-15650-1-git-send-email-teg@jklm.no> <20140130150503.GA29607@redhat.com>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 31 Jan 2014 01:54:03 +0100
Message-ID: <CAG-2HqVH5akkCY_d7=v-EECFzYTfT531t4g6zG9euC4+VgFLWw@mail.gmail.com>
Subject: Re: [PATCH] net: set default DEVTYPE for all ethernet based devices
To: Veaceslav Falico <vfalico@redhat.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Marcel Holtmann <marcel@holtmann.org>,
        Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Veaceslav,

Thanks for your quick reply.

On Thu, Jan 30, 2014 at 4:05 PM, Veaceslav Falico <vfalico@redhat.com> wrote:
> On Thu, Jan 30, 2014 at 02:20:02PM +0100, Tom Gundersen wrote:
>>
>> In systemd's networkd and udevd, we would like to give the administrator a
>> simple way to filter net devices by their DEVTYPE [0][1]. Other software
>> such as ConnMan and NetworkManager uses a similar filtering already.
>>
>> Currently, plain ethernet devices have DEVTYPE=(null). This patch sets the
>> devtype to "ethernet" instead. This avoids the need for special-casing the
>> DEVTYPE=(null) case in userspace, and also avoids false positives, as
>> there
>> are several other types of netdevs that also have DEVTYPE=(null).
>
>
> There are quite a few users at least in usb and wireless drivers:
>
> net#git grep alloc_etherdev drivers/net/wireless/ drivers/net/usb | wc -l
> 18
>
> In usb, though, there might be some false positives of this grep, as
> there are a few devices which might be considered ethernet.

Ah, yes I missed the #define of alloc_etherdev(). Looking through
these, it shouldn't be too hard to keep this patch and additionally
fix up the false positives to opt-out of setting the DEVTYPE. Does
that sound like something that would be acceptable?

Cheers,

Tom
