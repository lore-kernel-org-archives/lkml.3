Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3A1Qqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:46:30 -0500
Received: from stator.leun.net ([85.214.203.199]:45382 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab3A1Qq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:46:28 -0500
Date: Mon, 28 Jan 2013 17:42:07 +0100
From: Michael Leun <lkml20130126@newton.leun.net>
To: "Freddy" <freddy@asix.com.tw>
Cc: "=?ISO-8859-15?B?J0Jq+HJu?= Mork'" <bjorn@mork.no>,
        <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <louis@asix.com.tw>,
        <davem@davemloft.net>, <Support@asix.com.tw>
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
Message-ID: <20130128174207.1a38283d@xenia>
In-Reply-To: <010f01cdfd5c$768d4240$63a7c6c0$@asix.com.tw>
References: <1358908337-13841-1-git-send-email-freddy@asix.com.tw>
	<20130127001347.584711b2@xenia>
	<87zjztptez.fsf@nemi.mork.no>
	<010f01cdfd5c$768d4240$63a7c6c0$@asix.com.tw>
Organization: Not Organized
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.14; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013 21:36:20 +0800
"Freddy" <freddy@asix.com.tw> wrote:

> > I would vote to not accept that driver for mainline as long as this 
> > issues are not fixed.
> 
> 
> Michael, could you give me more information about how do you test
> this driver? I have tried to reproduce the issue by using "ifconfig
> ethX mtu 1500", but I didn't confront the same issue. Thank you in
> advance for your help.

I'm very sorry, but this seems to be some mistake on my side. I would
have sworn that I had done this also with mtu 1500, but now it looks
like you have to set the mtu to at least 1519 to see the issue (likely
an typo and I actually had set it to 1600):

jill:/home/ml # ifconfig eth3 192.168.123.2/24
jill:/home/ml # ifconfig eth3
eth3      Link encap:Ethernet  Hardware Adresse 00:24:9B:05:5C:E3  
          inet Adresse:192.168.123.2  Bcast:192.168.123.255  Maske:255.255.255.0
          inet6 Adresse: fe80::224:9bff:fe05:5ce3/64 Gültigkeitsbereich:Verbindung
          UP BROADCAST RUNNING MULTICAST  MTU:1488  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 Sendewarteschlangenlänge:1000 
          RX bytes:0 (0.0 b)  TX bytes:98 (98.0 b)

jill:/home/ml # ping 192.168.123.1
PING 192.168.123.1 (192.168.123.1) 56(84) bytes of data.
64 bytes from 192.168.123.1: icmp_seq=1 ttl=64 time=1.41 ms
64 bytes from 192.168.123.1: icmp_seq=2 ttl=64 time=0.969 ms
64 bytes from 192.168.123.1: icmp_seq=3 ttl=64 time=1.01 ms
^C
--- 192.168.123.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 0.969/1.131/1.412/0.199 ms
jill:/home/ml # ping -s 1491 192.168.123.1
PING 192.168.123.1 (192.168.123.1) 1491(1519) bytes of data.
1499 bytes from 192.168.123.1: icmp_seq=1 ttl=64 time=1.30 ms
1499 bytes from 192.168.123.1: icmp_seq=2 ttl=64 time=1.10 ms
1499 bytes from 192.168.123.1: icmp_seq=3 ttl=64 time=1.24 ms
^C
--- 192.168.123.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 1.109/1.218/1.306/0.086 ms
jill:/home/ml # ifconfig eth3 mtu 1519
jill:/home/ml # ping 192.168.123.1
PING 192.168.123.1 (192.168.123.1) 56(84) bytes of data.
64 bytes from 192.168.123.1: icmp_seq=1 ttl=64 time=1.11 ms
64 bytes from 192.168.123.1: icmp_seq=2 ttl=64 time=0.969 ms
^C
--- 192.168.123.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.969/1.042/1.115/0.073 ms
jill:/home/ml # ping -s 1491 192.168.123.1
PING 192.168.123.1 (192.168.123.1) 1491(1519) bytes of data.
^C
--- 192.168.123.1 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1000ms

jill:/home/ml # ping 192.168.123.1
PING 192.168.123.1 (192.168.123.1) 56(84) bytes of data.
^C
--- 192.168.123.1 ping statistics ---
6 packets transmitted, 0 received, 100% packet loss, time 4999ms

jill:/home/ml # 

-- 
MfG,

Michael Leun

