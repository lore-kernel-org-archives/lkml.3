Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3DVSt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 14:49:28 -0400
Received: from mout.gmx.net ([212.227.15.19]:61228 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab3DVSt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 14:49:27 -0400
X-Authenticated: #41704822
X-Provags-ID: V01U2FsdGVkX1+QQPhF7n2QlPz7uXIvCCwNDD8svNN2QMGMFXcJJd
	EVwL9HmX7beipX
Message-ID: <51758630.6000003@gmx.de>
Date: Mon, 22 Apr 2013 20:49:20 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Justin Maggard <jmaggard10@gmail.com>
CC: linux-kernel@vger.kernel.org, eparis@redhat.com, LinoSanfilippo@gmx.de,
        tzvetanc@commtouch.com
Subject: Re: fanotify: fix support of large files
References: <1360862966-6376-1-git-send-email-jmaggard10@gmail.com> <5169477D.1000400@gmx.de> <CAKgsxVT3_ge2vxcGWzy6NJYPEGwB1Wbw2eE7a=JtWWBb8o4XVg@mail.gmail.com>
In-Reply-To: <CAKgsxVT3_ge2vxcGWzy6NJYPEGwB1Wbw2eE7a=JtWWBb8o4XVg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Justin,

I downloaded the example,
http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
compiled it without modification
$ gcc fanotify-example.c -o fanotify-example
and started the executable. In a separate windows I executed
truncate -s 2048m 2048m

This is the output of the first window:
$ sudo ./fanotify-example /home/user/temp/
Started monitoring directory '/home/user/temp/'...
Received event in path '/home/user/temp/2048m' pid=3659 (truncate):
         FAN_OPEN
Received event in path '/home/user/temp/2048m' pid=3659 (truncate):
         FAN_CLOSE_WRITE

$ uname -a
Linux family2 3.8.0 #1 SMP Fri Feb 22 22:07:58 CET 2013 i686 GNU/Linux

To reproduce your problem, could you, please, provide the Linux 
configuration file (look in your /boot directory) and a link to the 
source of the Linux kernel version you use. Then I can use your 
configuration file to compile that kernel version.

Best regards

Heinrich Schuchardt

On 19.04.2013 21:23, Justin Maggard wrote:
> On Sat, Apr 13, 2013 at 4:54 AM, Heinrich Schuchardt<xypron.glpk@gmx.de>  wrote:
>> Dear Justin,
>>
>> looking at the example at
>> http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
>> the large file support is enabled by passing O_LARGEFILE to fanotify_init:
>>
>>    if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
>>                                      O_RDONLY | O_CLOEXEC | O_LARGEFILE))<
>> 0)
>>
>> Could you, please, check if this solves your issue.
>>
>> (I am resending this message because HTML was rejected by
>> linux-kernel@vger.kernel.org).
>>
>> Best regards
>>
>> Heinrich Schuchardt
>>
>
> No, unfortunately that doesn't help.  I slightly modifed
> fanotify-example.c to call perror() when read() fails, and here's the
> output:
>
> jmaggard@jmaggard-W520:~/fanotify-test$ sudo ./fanotify-example .&
> [1] 7248
> jmaggard@jmaggard-W520:~/fanotify-test$ Started monitoring directory '.'...
> truncate -s 2047m 2047m
> Received event in path '/home/jmaggard/fanotify-test/2047m' pid=7250 (unknown):
> FAN_OPEN
> FAN_CLOSE_WRITE
> jmaggard@jmaggard-W520:~/fanotify-test$ truncate -s 2048m 2048m
> read: Value too large for defined data type
>
> -Justin
>

