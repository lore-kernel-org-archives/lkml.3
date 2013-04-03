Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005Ab3DCSGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:06:48 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55931 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762890Ab3DCSGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:06:46 -0400
Message-ID: <515C6DCD.50902@mit.edu>
Date: Wed, 03 Apr 2013 10:58:37 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket
 is NULL
References: <20130402221104.163133110@linuxfoundation.org>  <20130402221116.307254752@linuxfoundation.org>  <87vc833kpf.fsf@turtle.gmx.de> <1364997630.13853.19.camel@edumazet-glaptop>  <87a9pfzm33.fsf@turtle.gmx.de> <1365003300.13853.25.camel@edumazet-glaptop>
In-Reply-To: <1365003300.13853.25.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 08:35 AM, Eric Dumazet wrote:
> On Wed, 2013-04-03 at 17:10 +0200, Sven Joachim wrote:
>> On 2013-04-03 16:00 +0200, Eric Dumazet wrote:
> 
>>
>>> It might be a wrong sender (application bug or bad identity), and udevd
>>> correctly discards the incoming message.
>>
>> How would I find out the culprit?
> 
> Change udevd to display the pid as well, and hopefully track the sender.
> 
> udevd receives uid and pid in the credentials.

This sounds suspiciously like an SCM_CREDENTIALS bug triggered by a
race.  There's a fix (that needs both a new version from me and a review
by someone) here:

http://www.spinics.net/lists/netdev/msg229948.html

--Andy
