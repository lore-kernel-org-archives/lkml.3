Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab3DCOAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:00:39 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:36778 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158Ab3DCOAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:00:34 -0400
Message-ID: <1364997630.13853.19.camel@edumazet-glaptop>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket
 is NULL
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 03 Apr 2013 07:00:30 -0700
In-Reply-To: <87vc833kpf.fsf@turtle.gmx.de>
References: <20130402221104.163133110@linuxfoundation.org>
	 <20130402221116.307254752@linuxfoundation.org>
	 <87vc833kpf.fsf@turtle.gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 13:41 +0200, Sven Joachim wrote:
> On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
> 
> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> 
> I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
> 3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
> patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
> here, and 65534 is the uid of user "nobody".

And if you use a 3.1 kernel (before commit
16e5726269611b71c930054ffe9b858c1cea88eb) are you seeing this message ?

It might be a wrong sender (application bug or bad identity), and udevd
correctly discards the incoming message.



