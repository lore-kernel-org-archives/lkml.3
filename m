Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3EaOrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:47:18 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:37546 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751921Ab3EaOrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:47:06 -0400
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Fri, 31 May 2013 16:47:00 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: Problem with ping command on 3.9.X compared to 3.2.45
Message-Id: <20130531164700.2d178364.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

is there a good reason why the ping command gets different answers from 3.[2-8] and 3.9 kernels? Please have a look at this output from strace:

First 3.2.45:

sendmsg(3, {msg_name(16)={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("1.2.3.4")}, msg_iov(1)=[{"\10\0\312\tO\17\0\1\207\252\250Q\0\0\0\0\352\26\6\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64}], msg_controllen=0, msg_flags=0}, 0) = 64
recvmsg(3, {msg_name(16)={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("5.6.7.8")}, msg_iov(1)=[{"E\300\0p\276\217\0\0@\1\210\257\331@@\5\331@@\10\5\1\341\272\331@@\3E\0\0T"..., 192}], msg_controllen=32, {cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=0x1d /* SCM_??? */, ...}, msg_flags=0}, 0) = 112
setsockopt(3, SOL_SOCKET, SO_ATTACH_FILTER, "\10\0\0\0\0\0\0\0@R\17\336\6\177\0\0", 16) = 0
recvmsg(3, 0x7fff1d5858f0, MSG_DONTWAIT) = -1 EAGAIN (Resource temporarily unavailable)

(Host X pinging to 1.2.3.4 gets a redirect from 5.6.7.8)

Now same situation on 3.9:

sendmsg(3, {msg_name(16)={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("1.2.3.4")}, msg_iov(1)=[{"\10\0tb\f\313\0\1q\250\250Q\0\0\0\0\232\4\4\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64}], msg_controllen=0, msg_flags=0}, 0) = 64
recvmsg(3, {msg_name(16)={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("5.6.7.8")}, msg_iov(1)=[{"E\300\0pI:\0\0@\1\375\376\331@@\5\331@@\16\5\1\341\272\331@@\3E\0\0T"..., 192}], msg_controllen=32, {cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=0x1d /* SCM_??? */, ...}, msg_flags=0}, 0) = 112
setsockopt(3, SOL_SOCKET, SO_ATTACH_FILTER, "\10\0\0\0\0\0\0\0\300\322M\5\315\177\0\0", 16) = 0
recvmsg(3, 0x7fff3c52a390, MSG_DONTWAIT) = -1 EHOSTUNREACH (No route to host)

This leads to a situation where "ping -w <deadline>" comes back immediately because it thinks there is some error. Whereas under 3.2.45 (upto 3.8 AFAIR) it waits <deadline> and receives answers.

Is there a reason for this behaviour change? Can this be tuned by some kernel options?
Please cc me in case of answer, it's hard to follow the complete list nowadays.
-- 
Regards,
Stephan
